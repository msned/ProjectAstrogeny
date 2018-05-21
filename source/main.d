module MainEntry;
import std.stdio;
import core.thread;
import derelict.glfw3.glfw3;
import derelict.opengl;
import Render.Window.WindowLoop;
import Render.RenderLoop;
import GameState;
import Render.Window.WindowObject;


//GLContext context;
void main() {
	DerelictGLFW3.load();
	DerelictGL3.load();
	if (!glfwInit())
		return;
	RenderInit();
	WindowObject first = CreateNewWindow("Project Astrogeny");
	glfwMakeContextCurrent(first.getGLFW());
	try {
		DerelictGL3.reload();
	} catch (Exception e) {
		writeln(DerelictGL3.loadedVersion);
	}
	running = true;
	auto mainthread = new Thread(&mainLoop).start();
	CreateNewWindow("Testing");
	WindowLoop();
	
}


void mainLoop() {
	while(running) {
		
	}
}
