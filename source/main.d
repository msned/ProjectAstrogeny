module MainEntry;

import std.stdio;
import core.thread;
import core.sync.mutex;
import derelict.glfw3.glfw3;
import derelict.opengl;
import derelict.util.exception : ShouldThrow;
import derelict.freetype;
import render.window.WindowLoop;
import GameState;
import render.window.WindowObject;
import render.window.DebugWindow;
import render.window.SettingsWindow;
import save.util.JSONLoading;
import save.util.SaveLoading;
import save.GameSave;

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
void main(string[] args) {
	DerelictGLFW3.load();
	DerelictGL3.load();
	DerelictFT.missingSymbolCallback = &missingSymCall;
	DerelictFT.load();
	if (!glfwInit())
		return;

	LoadSettings();

	if (args.length > 1) {
		writeln(args[1]);
		writeln("Loaded Save: ", LoadSave(args[1]).saveName);
	}

	StoreSave(NewGameSaveFile("testerino"));

	running = true;
	auto mainthread = new Thread(&mainLoop).start();

	//WindowObject deb = AddWindow(new DebugWindow());
	WindowObject settings = AddWindow(new SettingsWindow());

	WindowLoop();
}


void mainLoop() {
	while(running) {
		
	}
}
