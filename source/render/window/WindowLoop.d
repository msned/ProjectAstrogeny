module render.window.WindowLoop;

import derelict.glfw3.glfw3;
import derelict.opengl;
import render.window.WindowObject;
import render.RenderLoop;
import std.container.array;
import std.algorithm;
import std.range;
import std.stdio;
import core.thread;
import GameState;
import Settings;
import render.Fonts;
import render.responsiveControl.ResponsiveRegion;
import render.screenComponents;

__gshared WindowObject[] windowList;

int globalSwapInterval = 1;

public void WindowLoop() {
	Array!int removeList;
	while (running){
		foreach(i, current; windowList) {
			if (GameSettings.VSync && windowList.length > 1 && i != windowList.length - 1)
				glfwSwapInterval(0);
			OpenglPreRender();
			current.renderElements();
			glfwPollEvents();
			if (glfwWindowShouldClose(current.getGLFW())) {
				removeList.insertBack(i);
				break;
			}
			if (GameSettings.VSync && windowList.length > 1)
				glfwSwapInterval(1);
		}

		foreach(i; removeList) {
			RemoveWindow(i);
		}
		removeList.clear();
		if (windowList.length == 0)
			running = false;
	}
}

/++
Adds a new WindowObject to the window list for rendering and event polling
+/
public nothrow WindowObject AddWindow(WindowObject o) {
	windowList ~= o;
	return o;
}

public void RemoveWindow(int index) {
	windowList[index].onDestroy();
	glfwDestroyWindow(windowList[index].getGLFW());
	windowList = windowList.remove(index);
}

/++
Updates the swap interval for all open windows and any future windows
+/
public nothrow void UpdateSwapInterval(int newInterval) {
	GLFWwindow* current = glfwGetCurrentContext();
	foreach(WindowObject o; windowList) {
		glfwMakeContextCurrent(o.getGLFW());
		glfwSwapInterval(newInterval);
	}
	glfwMakeContextCurrent(current);
	globalSwapInterval = newInterval;
}

/++
Updates the font in all open windows to the newly selected one
+/
public nothrow void UpdateFonts() {
	GLFWwindow* current = glfwGetCurrentContext();
	foreach(WindowObject o; windowList) {
		glfwMakeContextCurrent(o.getGLFW());
		NewFont(o.windowID);
	}
	foreach(WindowObject o; windowList) {
		foreach(ResponsiveRegion r; o.regions)
			foreach(RenderObject g; r.getRenderObjects())
				if (auto t = cast(RenderText)g)
					t.setNewArray();
	}
	glfwMakeContextCurrent(current);
}