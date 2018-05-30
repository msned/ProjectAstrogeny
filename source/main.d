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
import render.screenComponents;
import GameState;
import render.window.WindowObject;
import render.window.DebugWindow;
import render.window.TestWindow;
import render.TextureUtil;
import render.Fonts;

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


	WindowObject first = AddWindow(new TestWindow("Project Astrogeny"));
	WindowObject deb = AddWindow(new DebugWindow());
	running = true;
	auto mainthread = new Thread(&mainLoop).start();

	WindowLoop();
}


void mainLoop() {
	while(running) {
		
	}
}
