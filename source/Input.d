module Input;

import derelict.glfw3;
import render.window.WindowObject;

extern(C)
nothrow void glfwKeyCallback(GLFWwindow* window, int key, int scancode, int action, int mods) {
	
}

extern(C)
nothrow void glfwCharCallback(GLFWwindow* window, uint codePoint) {
	auto winO = window in windowObjects;
	if (winO !is null) {
		winO.characterInput(codePoint);
	}
}

extern(C)
nothrow void glfwMouseButtonCallback(GLFWwindow* window, int button, int action, int mods) {
	auto winO = window in windowObjects;
	if (winO !is null) {
		if (action == GLFW_PRESS) {
			double xpos, ypos;
			glfwGetCursorPos(window, &xpos, &ypos);
			winO.mouseClick(xpos - winO.sizeX / 2, winO.sizeY / 2 - ypos, button);
		}
	}
}

extern(C)
nothrow void glfwScrollCallback(GLFWwindow* window, double xoffset, double yoffset) {
	
}
