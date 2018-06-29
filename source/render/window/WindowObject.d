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
		glfwWindowHint(GLFW_SAMPLES, 4);
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
		NewFont(windowID);
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
		pushScissor(0, 0, sizeX, sizeY);

		foreach(ResponsiveRegion r; regions)
			r.renderObjects();

		popScissor();
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
						s.scroll(x, y, null);
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

	const static int stackSize = 6;
	GLint[4][stackSize] scissorStack;		//Stack for the GLScissor tests
	int stackIndex = -1;

	/++
	Pushes another GLScissor frame onto the stack and sets the scissor boundaries
	+/
	public nothrow void pushScissor(int x, int y, int width, int height) {
		if (stackIndex >= stackSize - 1)
			return;
		stackIndex++;
		if (stackIndex == 0) {
			glScissor(x, y, width, height);
			scissorStack[stackIndex][0] = x;
			scissorStack[stackIndex][1] = y;
			scissorStack[stackIndex][2] = width;
			scissorStack[stackIndex][3] = height;
		} else {
			int x1 = x;
			int x2 = x + width;
			int y1 = y;
			int y2 = y + height;
			int x3 = scissorStack[stackIndex - 1][0];
			int x4 = x3 + scissorStack[stackIndex - 1][2];
			int y3 = scissorStack[stackIndex - 1][1];
			int y4 = y3 + scissorStack[stackIndex - 1][3];
			pragma(inline)
			int min(int x, int x2) {
				return (x > x2) ? x2 : x;
			}
			pragma(inline)
			int max(int x, int x2) {
				return (x > x2) ? x : x2;
			}
			int x5 = max(x1, x3);
			int y5 = max(y1, y3);
			int x6 = min(x2, x4);
			int y6 = min(y2, y4);
			if (x5 >= x6 || y5 >= y6) {
				glScissor(x3, y3, scissorStack[stackIndex - 1][2], scissorStack[stackIndex - 1][3]);
				scissorStack[stackIndex][0] = x3;
				scissorStack[stackIndex][1] = y3;
				scissorStack[stackIndex][2] = scissorStack[stackIndex - 1][2];
				scissorStack[stackIndex][3] = scissorStack[stackIndex - 1][3];
			} else {
				glScissor(x5, y5, x6 - x5, y6 - y5);
				scissorStack[stackIndex][0] = x5;
				scissorStack[stackIndex][1] = y5;
				scissorStack[stackIndex][2] = x6 - x5;
				scissorStack[stackIndex][3] = y6 - y5;
			}
		}
	}
	/++
	Pops the most recent GLScissor frame off of the stack and restores to the previous layer
	+/
	public nothrow void popScissor() {
		if (stackIndex < 0)
			return;
		stackIndex--;
		if (stackIndex == -1)
			return;
		glScissor(scissorStack[stackIndex][0], scissorStack[stackIndex][1], scissorStack[stackIndex][2], scissorStack[stackIndex][3]);
	}
	/++
	Returns the GLScissor frame from the top of the stack without popping it off
	+/
	public nothrow GLint[4] peekScissor() {
		return scissorStack[stackIndex];
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
