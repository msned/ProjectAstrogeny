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
			if (glfwWindowShouldClose(current.getGLFW())){
				removeList.insertBack(i);
				glfwDestroyWindow(current.getGLFW());
				break;
			}
			glfwSwapBuffers(current.getGLFW());
			glfwPollEvents();
			OpenglRender();
		}
		foreach(i; removeList){
			RemoveWindow(i);
		}
		removeList.clear();
		if (windowList.length == 0)
			running = false;
	}
}

WindowObject CreateNewWindow(string name) {
	WindowObject current = new WindowObject(name);
	windowList.assumeSafeAppend();
	windowList ~= current;
	return current;
}

void RemoveWindow(WindowObject o) {
	
}
void RemoveWindow(int index) {
	windowList = remove(windowList, index);
}