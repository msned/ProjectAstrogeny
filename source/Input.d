module Input;

import derelict.glfw3;
import render.window.WindowObject;
import std.stdio;

import render.window.WindowLoop;
import render.window.DebugWindow;
import render.window.SettingsWindow;

extern(C)
nothrow void glfwKeyCallback(GLFWwindow* window, int key, int scancode, int action, int mods) {
	if (checkHotKeys(key, action, mods))
		return;
	auto winO = window in windowObjects;
	if (winO !is null) {
		if (action == GLFW_PRESS)
			winO.keyInput(key, mods);
	}
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
		} else if (action == GLFW_RELEASE) {
			winO.mouseReleased();
		}
	}
}

nothrow void safeWrite(string s) {
	try {
		writeln(s);
	} catch (Exception e) {}
}

extern(C)
nothrow void glfwMouseEnterCallback(GLFWwindow* window, int entered) {
	if (entered) {

	} else {
		auto winO = window in windowObjects;
		if (winO !is null)
			winO.mouseReleased();
	}
}

extern(C)
nothrow void glfwCursorPositionCallback(GLFWwindow* window, double xPos, double yPos) {
	auto winO = window in windowObjects;
	if (winO !is null) {
		 winO.updateCursor(xPos - winO.sizeX / 2, winO.sizeY / 2 - yPos);
	}
}

extern(C)
nothrow void glfwScrollCallback(GLFWwindow* window, double xOffset, double yOffset) {
	auto winO = window in windowObjects;
	if (winO !is null) {
		winO.mouseScroll(xOffset, yOffset);
	}
}

/++
Manual checking of hotkeys for testing
+/
private nothrow bool checkHotKeys(int key, int action, int mods) {
	if (action == GLFW_PRESS && mods == GLFW_MOD_CONTROL) {
		if (key == GLFW_KEY_EQUAL) {
			try {
				AddWindow(new DebugWindow());
			} catch (Exception e) {assert(0);}
			return true;
		}
		else if (key == GLFW_KEY_MINUS) {
			try {
				AddWindow(new SettingsWindow());
			} catch (Exception e) {assert(0);}
			return true;
		}
		else if (key == GLFW_KEY_S) {
			import save.SaveData;
			try {
				SaveGameFiles();
			} catch (Exception e) { assert(0); }
			return true;
		}
	}
	return false;
}
