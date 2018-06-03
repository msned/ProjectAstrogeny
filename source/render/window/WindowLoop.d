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

__gshared WindowObject[] windowList;

public void WindowLoop() {
	Array!int removeList;
	while (running){
		glfwSwapInterval(0);
		foreach(i, current; windowList) {
			OpenglPreRender();
			current.renderElements();
			glfwPollEvents();
			if (glfwWindowShouldClose(current.getGLFW())){
				removeList.insertBack(i);
				break;
			}
		}
		glfwSwapInterval(1);

		foreach(i; removeList){
			RemoveWindow(i);
		}
		removeList.clear();
		if (windowList.length == 0)
			running = false;
	}
}

WindowObject AddWindow(WindowObject o) {
	windowList ~= o;
	return o;
}

void RemoveWindow(int index) {
	windowList[index].onDestroy();
	glfwDestroyWindow(windowList[index].getGLFW());
	windowList = remove(windowList, index);
}