module render.window.WindowObject;

import derelict.opengl;
import derelict.glfw3.glfw3;
import render.RenderObject;
import render.RenderLoop;
import render.screenComponents.Text;
import render.Fonts;
import std.uuid;

WindowObject[GLFWwindow*] windowObjects;

class WindowObject {
	GLFWwindow* window;

	public UUID windowID;

	RenderObject[] objects;

	public int sizeX, sizeY;
	string windowName;

	GLFWwindow* getGLFW() { return window; }

	this(string name, int x = 960, int y = 540) {
		window = glfwCreateWindow(x, y, cast(char*)name, null, null);
		sizeX = x;
		sizeY = y;
		windowName = name;
		windowID = randomUUID();
		glfwSetWindowSizeCallback(window, &windowResize);

		windowObjects[window] = this;
		glfwMakeContextCurrent(window);
		RenderInit();
		FontInit();
	}
	private void AddObject(RenderObject obj) {
		objects ~= obj;
	}
	public RenderObject addObject(string textureName) {
		GLFWwindow* old = glfwGetCurrentContext();
		glfwMakeContextCurrent(window);
		RenderObject o = new RenderObject(textureName, this);
		//RenderObject.glOrtho(0, sizeX, 0, sizeY, -10, 10, windowID);
		AddObject(o);
		glfwMakeContextCurrent(old);
		return o;
	}
	public RenderText addText(string text, float xPos, float yPos, float scale) {
		GLFWwindow* old = glfwGetCurrentContext();
		glfwMakeContextCurrent(window);
		RenderText t = new RenderText(text, xPos, yPos, scale, this);
		AddObject(t);
		glfwMakeContextCurrent(old);
		return t;
	}

	public void renderObjects() {
		glViewport(0, 0, sizeX, sizeY);
		foreach(RenderObject o; objects) {
			o.render();
		}
	}
	nothrow public void setSize(int x, int y) {
		sizeX = x;
		sizeY = y;
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
