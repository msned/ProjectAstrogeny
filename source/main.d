module MainEntry;

import std.stdio;
import core.thread;
import core.sync.mutex;
import derelict.glfw3.glfw3;
import derelict.opengl;
import derelict.util.exception : ShouldThrow;
import derelict.freetype;
import render.window.WindowLoop;
import render.RenderLoop;
import render.RenderObject;
import render.screenComponents.Text;
import GameState;
import render.window.WindowObject;
import render.TextureUtil;
import render.Fonts;

__gshared WindowObject[] windows;
shared Mutex windowMtx;

ShouldThrow missingSymCall(string symbolName) {
	if(	symbolName == "FT_Stream_OpenBzip2" ||
		symbolName == "FT_Get_CID_Registry_Ordering_Supplement" ||
		symbolName == "FT_Get_CID_Is_Internally_CID_Keyed" ||
		symbolName == "FT_Get_CID_From_Glyph_Index") {
		return ShouldThrow.No;
	   } else {
		return ShouldThrow.Yes;
	   }
}

//GLContext context;
void main() {
	DerelictGLFW3.load();
	DerelictGL3.load();
	DerelictFT.missingSymbolCallback = &missingSymCall;
	DerelictFT.load();
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
	test.addObject("file_edit.png");
	RenderObject xd = first.addObject("file_edit.png");
	RenderObject fileNew = test.addObject("file_new.png");
	RenderObject fileSearch = first.addObject("file_search.png");
	fileSearch.shiftPosition(-80f, -80f);
	fileNew.scalePosition(100f, 100f);
	fileNew.shiftPosition(40f, 20f);
	fileNew.setDepth(0.9f);
	first.addObject("random2.png");
	first.addText("alpha", 0, 100, .5f);
	xd.scalePosition(130f, 130f);
	xd.setDepth(.2f);
	windowMtx.unlock();

	WindowLoop();
}


void mainLoop() {
	while(running) {
		windowMtx.lock();
		WindowObject o = windows[0];
		if (o.objects.length > 0)
			o.objects[0].scalePosition(85f, 85f);
		windowMtx.unlock();
	}
}
