module Render.Window.WindowObject;
import derelict.opengl;
import derelict.glfw3.glfw3;
import Render.RenderObject;
import Render.RenderLoop;
import std.uuid;

class WindowObject {
	GLFWwindow* window;

	UUID windowID;

	RenderObject[] objects;

	int sizeX, sizeY;
	string windowName;

	this(string name, int x = 960, int y = 540) {
		window = glfwCreateWindow(x, y, cast(char*)name, null, null);
		sizeX = x;
		sizeY = y;
		windowName = name;
		windowID = randomUUID();
		glfwMakeContextCurrent(window);
		RenderInit();
	}
	private void AddObject(RenderObject obj) {
		objects ~= obj;
	}
	public void AddObject(string textureName) {
		GLFWwindow* old = glfwGetCurrentContext();
		glfwMakeContextCurrent(window);
		AddObject(new RenderObject(textureName, windowID));
		glfwMakeContextCurrent(old);
	}

	public void RenderObjects() {
		glViewport(0, 0, sizeX, sizeY);
		foreach(RenderObject o; objects) {
			o.render();
		}
	}

	GLFWwindow* getGLFW() { return window; }
}
