module save.SaveData;

import save.util.JSONLoading;
import save.util.SaveLoading;
import std.stdio;
import core.sync.mutex;
import std.exception;
import save;

private __gshared GameSave loadedSave;
public shared Mutex gameSaveMutex;

private string loadedSavePath;

enum SaveComponentNames {stations = "_stations", ships = "_ships", colonies = "_colonies", world = "_world" };

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
}

public void NewGameFiles(string gameName) {
	loadedSave = NewGameSave(gameName);
	SaveGameFiles();
}

public const(GameSave)* readonlyGameSave() {
	return &loadedSave;
}

public GameSave getGameSave() {
	enforce(gameSaveMutex.tryLock(), "lock is required before obtaining GameSave");
	return loadedSave;
}
