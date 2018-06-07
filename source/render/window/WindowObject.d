module render.window.WindowObject;

import derelict.opengl;
import derelict.glfw3.glfw3;
import core.sync.mutex;
import render.RenderObject;
import render.RenderLoop;
import render.screenComponents;
import render.responsiveControl;
import render.Fonts;
import Input;
import std.uuid;
import std.stdio;
import std.conv;

WindowObject[GLFWwindow*] windowObjects;

enum WindowCursor {hResize, vResize, iBeam, arrow};

abstract class WindowObject {
	protected GLFWwindow* window;

	public UUID windowID;

	RenderObject[] objects;

	ResponsiveRegion[] regions;

	public int sizeX, sizeY;
	public string windowName;

	public float cursorXPos, cursorYPos;

	static GLFWcursor* hResize, vResize, iBeam, arrow;

	GLFWwindow* getGLFW() { return window; }

	this(string name, int x = 960, int y = 540) {
		window = glfwCreateWindow(x, y, cast(char*)name, null, null);
		sizeX = x;
		sizeY = y;
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
		//Render Setup
		RenderInit();
		FontInit();
		loadRenderObjects();
		updateResponsiveElements();
		glfwMakeContextCurrent(old);
	}

	public nothrow void renderElements() {
		glfwMakeContextCurrent(window);
		OpenglPreRender();
		renderObjects();
		glfwSwapBuffers(window);
	}

	public nothrow abstract void characterInput(uint i);

	protected abstract void loadRenderObjects();

	public nothrow void renderObjects() {
		glViewport(0, 0, sizeX, sizeY);
		glScissor(0, 0, sizeX, sizeY);
		//TODO: Depreciate direct object rendering
		foreach(RenderObject o; objects) {
			o.render();
		}

		foreach(ResponsiveRegion r; regions)
			r.renderObjects();
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
			foreach(RenderObject o; r.getRenderObjects()) {
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
			foreach(RenderObject o; r.getRenderObjects())
				if (auto a = cast(Clickable)o)
					a.mouseReleased();
		}
	}


	public nothrow void mouseClick(float x, float y, int button) {
		foreach(ResponsiveRegion r; regions) {
			foreach(RegionBoarder b; r.boarders)
				if (b.checkClick(x, y, button))
					return;
			foreach(RenderObject o; r.getRenderObjects())
				if (auto b = cast(Clickable)o)
					if (b.checkClick(x, y, button))
						return;
		}
	}


	public void onDestroy() {
		RenderObject.onDestroyWindow(windowID);
		foreach(ResponsiveRegion r; regions) {
			foreach(RegionBoarder b; r.boarders)
				b.onDestroy();
			foreach(RenderObject o; r.getRenderObjects())
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
