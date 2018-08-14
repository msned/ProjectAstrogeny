module save.SaveData;

import save.util.JSONLoading;
import save.util.SaveLoading;
import std.stdio;
import core.sync.mutex;
import std.exception;
import save;
import Settings;

private __gshared GameSave loadedSave;
public shared Mutex worldSaveMutex, shipSaveMutex, stationSaveMutex, colonySaveMutex;

private string loadedSavePath;

enum SaveComponentNames {stations = "_stations", ships = "_ships", colonies = "_colonies", world = "_world" };

/++
Loads the game files from disc at the string path given, returns true on success
+/
public bool LoadGameFiles(string pathtoGameSave) {
	loadedSave = LoadSave!GameSave(pathtoGameSave);
	if (loadedSave is null)
		return false;
	loadedSavePath = pathtoGameSave[0 .. $ - loadedSave.saveName.length - saveSuffix.length];

	loadedSave.stations = LoadSave!StationSave(loadedSavePath ~ loadedSave.saveName ~ SaveComponentNames.stations ~ saveSuffix);
	if (loadedSave.stations is null)
		return false;
	loadedSave.ships = LoadSave!ShipSave(loadedSavePath ~ loadedSave.saveName ~ SaveComponentNames.ships ~ saveSuffix);
	if (loadedSave.ships is null)
		return false;
	loadedSave.colonies = LoadSave!ColonySave(loadedSavePath ~ loadedSave.saveName ~ SaveComponentNames.colonies ~ saveSuffix);
	if (loadedSave.colonies is null)
		return false;
	loadedSave.world = LoadSave!WorldSave(loadedSavePath ~ loadedSave.saveName ~ SaveComponentNames.world ~ saveSuffix);
	if (loadedSave.world is null)
		return false;
	return true;
}

/++
Stores the currently loaded save to disc
+/
public void SaveGameFiles() {
	if (loadedSave is null)
		return;
	if (loadedSavePath is null)
		loadedSavePath = defaultSaveLocation;
	StoreSave(loadedSave.stations, loadedSave.saveName ~ SaveComponentNames.stations, loadedSavePath);
	StoreSave(loadedSave.ships, loadedSave.saveName ~ SaveComponentNames.ships, loadedSavePath);
	StoreSave(loadedSave.colonies, loadedSave.saveName ~ SaveComponentNames.colonies, loadedSavePath);
	StoreSave(loadedSave.world, loadedSave.saveName ~ SaveComponentNames.world, loadedSavePath);
	StoreSave(loadedSave, loadedSave.saveName, loadedSavePath);

	static if (DEBUG)
		writeln("Saved ", loadedSave.saveName);
}

/++
Creates a new Game Save, loads it, and saves it to disc
+/
public void NewGameFiles(string gameName) {
	loadedSave = NewGameSave(gameName);
	SaveGameFiles();
}

/++
Returns a const pointer to the game save for read-only access
Used for reading without using a Mutex lock
+/
public const(GameSave)* readonlyGameSave() {
	return &loadedSave;
}

/++
Returns the currently loaded save, fails assert if none loaded
Must use the mutex locks before writing any data to the save
+/
public nothrow GameSave getGameSave() {
	assert(loadedSave !is null, "No game save loaded");
	return loadedSave;
}

/++
Loads the settings file and sets various information as needed
+/
public void LoadGameSettings() {
	LoadSettingsFile();
	import render.window.WindowLoop;
	globalSwapInterval = cast(int)GameSettings.VSync;
}

public void SaveGameSettings() {
	SaveSettingsFile();
}

public void genMutexes() {
	worldSaveMutex = new shared Mutex();
	shipSaveMutex = new shared Mutex();
	stationSaveMutex = new shared Mutex();
	colonySaveMutex = new shared Mutex();
}
