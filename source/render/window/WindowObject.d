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

WindowObject[GLFWwindow*] windowObjects;

abstract class WindowObject {
	protected GLFWwindow* window;

	public UUID windowID;

	RenderObject[] objects;

	ResponsiveRegion left, top, right, bottom, center;

	public int sizeX, sizeY;
	public string windowName;

	GLFWwindow* getGLFW() { return window; }

	this(string name, int x = 960, int y = 540) {
		window = glfwCreateWindow(x, y, cast(char*)name, null, null);
		sizeX = x;
		sizeY = y;
		windowName = name;
		windowID = randomUUID();
		glfwSetWindowSizeCallback(window, &windowResize);
		glfwSetKeyCallback(window, &glfwKeyCallback);
		glfwSetCharCallback(window, &glfwCharCallback);
		glfwSetScrollCallback(window, &glfwScrollCallback);
		glfwSetMouseButtonCallback(window, &glfwMouseButtonCallback);
		windowObjects[window] = this;
		GLFWwindow* old = glfwGetCurrentContext();
		glfwMakeContextCurrent(window);
		RenderInit();
		FontInit();
		loadRenderObjects();
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

		if (left !is null)
			left.renderObjects();
		if (top !is null)
			top.renderObjects();
		if (right !is null)
			right.renderObjects();
		if (bottom !is null)
			bottom.renderObjects();
		if (center !is null)
			center.renderObjects();

		RenderObject.updateOrtho[windowID] = false;
	}

	protected nothrow updateResponsiveElements() {
		//Scale top and bottom first, the left and right, then center fills the gaps
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
		winO.setSize(width, height);
		RenderObject.glOrtho(0, width, 0, height, -10, 10, winO.windowID);
	}
}

extern (C)
nothrow void windowRefresh(GLFWwindow* window) {
	OpenglPreRender();
}
