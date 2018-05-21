module MainEntry;
import std.stdio;
import core.thread;
import derelict.glfw3.glfw3;
import derelict.opengl;
import Render.Window.WindowLoop;
import Render.RenderLoop;
import Render.RenderObject;
import GameState;
import Render.Window.WindowObject;
import Render.TextureUtil;


//GLContext context;
void main() {
	DerelictGLFW3.load();
	DerelictGL3.load();
	if (!glfwInit())
		return;
	WindowObject first = CreateNewWindow("Project Astrogeny", 540, 540);
	WindowObject test = CreateNewWindow("Testing");
	running = true;
	auto mainthread = new Thread(&mainLoop).start();
	test.AddObject("file_edit.png");
	first.AddObject("file_new.png");
	first.AddObject("file_search.png");
	WindowLoop();
	
}


void mainLoop() {
	while(running) {
		
	}
}
