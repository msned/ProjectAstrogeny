module Render.Window.WindowObject;
import derelict.opengl;
import derelict.glfw3.glfw3;

class WindowObject {
	GLFWwindow* window;

	this(string name, int x = 960, int y = 540) {
		window = glfwCreateWindow(x, y, cast(char*)name, null, null);
	}

	GLFWwindow* getGLFW() { return window; }
}
