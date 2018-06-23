module render.window.WindowObject;

import derelict.opengl;
import derelict.glfw3.glfw3;
import core.sync.mutex;
import render.RenderObject;
import render.RenderLoop;
import render.window.WindowLoop;
import render.screenComponents;
import render.responsiveControl;
import render.Fonts;
import Input;
import std.uuid;
import std.stdio;
import std.datetime;
import Settings;
import ships;
import save;

WindowObject[GLFWwindow*] windowObjects;

enum WindowCursor {hResize, vResize, iBeam, arrow};

abstract class WindowObject {
	protected GLFWwindow* window;

	public UUID windowID;
	ResponsiveRegion[] regions;

	public int sizeX, sizeY;
	public string windowName;

	public float cursorXPos, cursorYPos;
	private static GLFWcursor* hResize, vResize, iBeam, arrow;

	public void delegate(long) nothrow [] animationCalls;

	public Inputable[] inputs;

	public nothrow GLFWwindow* getGLFW() { return window; }

	this(string name, int x = 540, int y = 540) {
		sizeX = cast(int)(x * GameSettings.GUIScale);
		sizeY = cast(int)(y * GameSettings.GUIScale);
		window = glfwCreateWindow(sizeX, sizeY, cast(char*)name, null, null);
		windowName = name;
		windowID = randomUUID();
		//GLFW setup
		glfwSetFramebufferSizeCallback(window, &windowResize);
		glfwSetKeyCallback(window, &glfwKeyCallback);
		glfwSetCharCallback(window, &glfwCharCallback);
		glfwSetScrollCallback(window, &glfwScrollCallback);
		glfwSetMouseButtonCallback(window, &glfwMouseButtonCallback);
		glfwSetCursorPosCallback(window, &glfwCursorPositionCallback);
		glfwSetCursorEnterCallback(window, &glfwMouseEnterCallback);
		glfwSetWindowRefreshCallback(window, &windowRefresh);

		hResize = glfwCreateStandardCursor(GLFW_HRESIZE_CURSOR);
		vResize = glfwCreateStandardCursor(GLFW_VRESIZE_CURSOR);
		iBeam = glfwCreateStandardCursor(GLFW_IBEAM_CURSOR);
		arrow = glfwCreateStandardCursor(GLFW_ARROW_CURSOR);

		windowObjects[window] = this;
		RenderObject.orthoUpdates[windowID] = [];
		GLFWwindow* old = glfwGetCurrentContext();
		glfwMakeContextCurrent(window);
		glfwSwapInterval(globalSwapInterval);
		//Render Setup
		RenderInit();
		FontInit();
		loadRenderObjects();
		foreach(ResponsiveRegion r; regions)
			r.postInit(sizeX, sizeY);
		sortRegions();

		updateResponsiveElements();
		glfwMakeContextCurrent(old);
		oldTime = Clock.currTime.stdTime;
	}

	public nothrow void renderElements() {
		glfwMakeContextCurrent(window);
		OpenglPreRender();
		animateObjects();
		renderObjects();
		glfwSwapBuffers(window);
	}

	public nothrow void characterInput(uint c) {
		foreach(Inputable i; inputs)
			if (i.isFocused())
				i.charInput(c);
	}

	public nothrow void keyInput(int key, int mod) {
		foreach(Inputable i; inputs)
			if (i.isFocused())
				i.keyInput(key, mod);
	}

	protected abstract void loadRenderObjects();

	public nothrow void renderObjects() {
		glViewport(0, 0, sizeX, sizeY);
		glScissor(0, 0, sizeX, sizeY);

		foreach(ResponsiveRegion r; regions)
			r.renderObjects();
	}

	long oldTime;
	protected nothrow void animateObjects() {
		long t;
		try {t = Clock.currTime.stdTime; } catch (Exception e) {assert(0); }
		foreach(void delegate(long) nothrow d; animationCalls)
			d((t - oldTime) / 10000);
		oldTime = t;
	}

	protected nothrow void updateResponsiveElements() {
		foreach(ResponsiveRegion r; regions)
			r.clearHidden();
		responsiveElementsLoop();
	}
	protected nothrow void responsiveElementsLoop() {
		foreach(ResponsiveRegion r; regions)
			r.clearBounds();
		foreach(ResponsiveRegion r; regions)
			if (!r.updateElements(sizeX, sizeY)) {
				responsiveElementsLoop();
				break;
			}
	}

	/++
	Sorts the region array in decending order of priority
	+/
	protected void sortRegions() {
		for(int i = regions.length - 1; i > 0; i--) {		//bubble sort for in-place space efficiency and best case for a mostly sorted list
			for(int j = 0; j < i; j++) {
				if (regions[j].priority < regions[j+1].priority) {
					ResponsiveRegion tmp = regions[j+1];
					regions[j+1] = regions[j];
					regions[j] = tmp;
				}
			}
		}
	}

	/++
	Sets the size of the window, updates all Responsive elements as needed
	+/
	public nothrow void setSize(int x, int y) {
		sizeX = x;
		sizeY = y;
		updateResponsiveElements();
	}

	public nothrow void updateCursor(float x, float y) {
		cursorXPos = x;
		cursorYPos = y;
		foreach(ResponsiveRegion r; regions) {
			foreach(RegionBoarder b; r.boarders)
				if (b.checkPosition(x, y))
					return;
			foreach(RegionBoarder b; r.boarders)
				if (b.checkHover(x, y))
					return;
			foreach(RenderObject o; r.getRenderObjects() ~ r.getFixedRenderObjects()) {
				if (auto a = cast(Hoverable)o)
					a.checkHover(x, y);
				if (auto a = cast(Draggable)o)
					if (a.checkPosition(x, y))
						return;
			}
		}
	}

	public nothrow void mouseReleased() {
		foreach(ResponsiveRegion r; regions) {
			foreach(RegionBoarder b; r.boarders)
				b.mouseReleased();
			foreach(RenderObject o; r.getRenderObjects() ~ r.getFixedRenderObjects())
				if (auto a = cast(Clickable)o)
					a.mouseReleased();
		}
	}


	public nothrow void mouseClick(float x, float y, int button) {
		foreach(ResponsiveRegion r; regions) {
			foreach(RegionBoarder b; r.boarders)
				if (b.checkClick(x, y, button))
					return;
			foreach(RenderObject o; r.getRenderObjects() ~ r.getFixedRenderObjects())
				if (auto b = cast(Clickable)o)
					if (b.checkClick(x, y, button))
						return;
		}
		ClearFocus();
	}

	public nothrow void mouseScroll(float x, float y) {
		foreach(ResponsiveRegion r; regions)
			foreach(RenderObject o; r.getRenderObjects() ~ r.getFixedRenderObjects())
				if(o.within(cursorXPos, cursorYPos))
					if (auto s = cast(Scrollable)o) {
						s.scroll(x, y);
						return;
					}

	}


	public void onDestroy() {
		RenderObject.onDestroyWindow(windowID);
		foreach(ResponsiveRegion r; regions) {
			foreach(RegionBoarder b; r.boarders)
				b.onDestroy();
			foreach(RenderObject o; r.getRenderObjects() ~ r.getFixedRenderObjects())
				o.onDestroy();
		}
	}

	public nothrow void setCursor(WindowCursor c = WindowCursor.arrow) {
		switch(c) {
			default:
			case WindowCursor.arrow:
				glfwSetCursor(window, arrow);
				break;
			case WindowCursor.hResize:
				glfwSetCursor(window, hResize);
				break;
			case WindowCursor.vResize:
				glfwSetCursor(window, vResize);
				break;
			case WindowCursor.iBeam:
				glfwSetCursor(window, iBeam);
				break;
		}
	}

}

nothrow void writelnNothrow(T)(T s) {
	try {
		writeln(s);
	} catch (Exception e) {}
}

extern (C)
nothrow void windowResize(GLFWwindow* window, int width, int height) {
	auto winO = window in windowObjects;
	if (winO !is null) {
		glfwMakeContextCurrent(window);
		winO.setSize(width, height);
		RenderObject.updateOrtho(width, height, winO.windowID);
	}
}

extern (C)
nothrow void windowRefresh(GLFWwindow* window) {
	auto winO = window in windowObjects;
	if (winO !is null) {
		winO.renderElements();
	}
}
