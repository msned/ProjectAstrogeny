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

abstract class WindowObject {
	protected GLFWwindow* window;

	public UUID windowID;

	RenderObject[] objects;

	ResponsiveRegion[] regions;

	public int sizeX, sizeY;
	public string windowName;

	GLFWwindow* getGLFW() { return window; }

	this(string name, int x = 960, int y = 540) {
		window = glfwCreateWindow(x, y, cast(char*)name, null, null);
		sizeX = x;
		sizeY = y;
		windowName = name;
		windowID = randomUUID();
		glfwSetFramebufferSizeCallback(window, &windowResize);
		glfwSetKeyCallback(window, &glfwKeyCallback);
		glfwSetCharCallback(window, &glfwCharCallback);
		glfwSetScrollCallback(window, &glfwScrollCallback);
		glfwSetMouseButtonCallback(window, &glfwMouseButtonCallback);
		glfwSetWindowRefreshCallback(window, &windowRefresh);
		windowObjects[window] = this;
		RenderObject.orthoUpdates[windowID] = new void delegate(GLdouble, GLdouble, UUID) nothrow[1];
		GLFWwindow* old = glfwGetCurrentContext();
		glfwMakeContextCurrent(window);
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

	protected void addObject(RenderObject obj) {
		objects ~= obj;
		sortRenderObjects();
	}

	deprecated
	public RenderObject addObject(string textureName) {
		GLFWwindow* old = glfwGetCurrentContext();
		glfwMakeContextCurrent(window);
		RenderObject o = new RenderObject(textureName, this);
		//RenderObject.glOrtho(0, sizeX, 0, sizeY, -10, 10, windowID);
		addObject(o);
		glfwMakeContextCurrent(old);
		return o;
	}

	deprecated
	public RenderText addText(string text, float xPos, float yPos, float scale) {
		GLFWwindow* old = glfwGetCurrentContext();
		glfwMakeContextCurrent(window);
		RenderText t = new RenderText(text, xPos, yPos, scale, this);
		addObject(t);
		glfwMakeContextCurrent(old);
		return t;
	}

	/++
	Sorts the RenderObject array with highest depth first
	++/
	protected void sortRenderObjects() {
		for(int i = objects.length - 1; i > 0; i--) {		//bubble sort for in-place space efficiency and best case for a mostly sorted list
			for(int j = 0; j < i; j++) {
				if (objects[j].getDepth() < objects[j+1].getDepth()) {
					RenderObject tmp = objects[j+1];
					objects[j+1] = objects[j];
					objects[j] = tmp;
				}
			}
		}
	}

	public nothrow abstract void characterInput(uint i);

	//0 for left click, 1 for right click
	public nothrow void mouseClick(float x, float y, int button) {
		foreach(RenderObject o; objects) {
			if (auto b = cast(Clickable)o)
				b.checkClick(x, y, button);
		}
	}

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
	Sets the size of the window, updates all Responsive elements as needed
	+/
	public nothrow void setSize(int x, int y) {
		sizeX = x;
		sizeY = y;
		updateResponsiveElements();
	}

	public void onDestroy() {
		RenderObject.onDestroyWindow(windowID);
		foreach(RenderObject o; objects) {
			o.onDestroy();
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
