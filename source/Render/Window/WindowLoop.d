module Render.Window.WindowLoop;
import derelict.glfw3.glfw3;
import derelict.opengl;
import Render.Window.WindowObject;
import Render.RenderLoop;
import std.container.array;
import std.algorithm;
import std.range;
import core.thread;
import GameState;

WindowObject[] windowList;

public void WindowLoop() {
	Array!int removeList;
	while (running){
		foreach(i, current; windowList) {
			glfwMakeContextCurrent(current.getGLFW());
			OpenglPreRender();
			current.RenderObjects();
			glfwSwapBuffers(current.getGLFW());
			glfwPollEvents();
			if (glfwWindowShouldClose(current.getGLFW())){
				removeList.insertBack(i);
				glfwDestroyWindow(current.getGLFW());
			}
		}
		foreach(i; removeList){
			RemoveWindow(i);
		}
		removeList.clear();
		if (windowList.length == 0)
			running = false;
	}
}

WindowObject CreateNewWindow(string name, int x = 960, int y = 540) {
	WindowObject current = new WindowObject(name, x, y);
	windowList.assumeSafeAppend();
	windowList ~= current;
	return current;
}

void RemoveWindow(WindowObject o) {
	
}
void RemoveWindow(int index) {
	windowList = remove(windowList, index);
}