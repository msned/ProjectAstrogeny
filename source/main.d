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
import render.window.ChartTestWindow;
import render.window.MapWindow;

import logic.LogicLoop;
import save.SaveData;
import save.GameSave;
import render.Fonts;
import world.Resources;

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

	LoadGameSettings();
	genMutexes();

	FontInit();
	InstantiateResources();

	if (args.length > 1) {
		writeln(args[1]);
		LoadGameFiles(args[1]);
	} else {
		NewGameFiles("testerino");
	}

	running = true;
	auto mainthread = new Thread(&MainLoop).start();

	//AddWindow(new DebugWindow());
	AddWindow(new SettingsWindow());
	//AddWindow(new ChartTestWindow());
	AddWindow(new MapWindow());

	testCode();

	WindowLoop();
}

import colonies;
import std.uuid;
import render.window.ChartWindow;

void testCode() {
	UUID planetID = randomUUID();
	ColonyBase b = new ColonyBase();
	b.cht = cast(ChartWindow)AddWindow(new ChartWindow());
	colonySaveMutex.lock();
	getGameSave().colonies.colonies[planetID] = b;
	colonySaveMutex.unlock();
}
