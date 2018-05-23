module MainEntry;
import std.stdio;
import core.thread;
import core.sync.mutex;
import derelict.glfw3.glfw3;
import derelict.opengl;
import Render.Window.WindowLoop;
import Render.RenderLoop;
import Render.RenderObject;
import GameState;
import Render.Window.WindowObject;
import Render.TextureUtil;

__gshared WindowObject[] windows;
shared Mutex windowMtx;

//GLContext context;
void main() {
	DerelictGLFW3.load();
	DerelictGL3.load();
	if (!glfwInit())
		return;
	WindowObject first = CreateNewWindow("Project Astrogeny", 540, 540);
	WindowObject test = CreateNewWindow("Testing");
	windows ~= first;
	windows ~= test;
	running = true;
	windowMtx = new shared Mutex();
	auto mainthread = new Thread(&mainLoop).start();

	//Testing for adding objects to windows
	windowMtx.lock();
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
	windowMtx.unlock();
	WindowLoop();
	
}


void mainLoop() {
	while(running) {
		windowMtx.lock();
		WindowObject o = windows[0];
		if (o.objects.length > 0)
			o.objects[0].ScalePosition(85f, 85f);
		windowMtx.unlock();
	}
}
