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
	RenderObject xd = first.AddObject("file_edit.png");
	RenderObject fileNew = test.AddObject("file_new.png");
	RenderObject fileSearch = first.AddObject("file_search.png");
	fileSearch.ShiftPosition(-80f, -80f);
	fileNew.ScalePosition(100f, 100f);
	fileNew.ShiftPosition(40f, 20f);
	fileNew.SetDepth(0.9f);
	first.AddObject("random2.png");
	xd.ScalePosition(130f, 130f);
	xd.SetDepth(.2f);
	
	WindowLoop();
	
}


void mainLoop() {
	while(running) {
		
	}
}
