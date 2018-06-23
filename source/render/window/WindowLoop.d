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

__gshared WindowObject[] windowList;

int globalSwapInterval = 1;

public void WindowLoop() {
	Array!int removeList;
	while (running){
		if (GameSettings.VSync && windowList.length > 1)
			glfwSwapInterval(0);
		foreach(i, current; windowList) {
			OpenglPreRender();
			current.renderElements();
			glfwPollEvents();
			if (glfwWindowShouldClose(current.getGLFW())) {
				removeList.insertBack(i);
				break;
			}
		}
		if (GameSettings.VSync && windowList.length > 1)
			glfwSwapInterval(1);

		foreach(i; removeList){
			RemoveWindow(i);
		}
		removeList.clear();
		if (windowList.length == 0)
			running = false;
	}
}

public WindowObject AddWindow(WindowObject o) {
	windowList ~= o;
	return o;
}

public void RemoveWindow(int index) {
	windowList[index].onDestroy();
	glfwDestroyWindow(windowList[index].getGLFW());
	windowList = windowList.remove(index);
}

public nothrow void UpdateSwapInterval(int newInterval) {
	GLFWwindow* current = glfwGetCurrentContext();
	foreach(WindowObject o; windowList) {
		glfwMakeContextCurrent(o.getGLFW());
		glfwSwapInterval(newInterval);
	}
	glfwMakeContextCurrent(current);
	globalSwapInterval = newInterval;
}