module save.GameSave;

import std.datetime;

class GameSaveFile {
	
	string saveName;

	//SysTime creationDate;


}

GameSaveFile NewGameSaveFile(string saveName) {
	GameSaveFile g = new GameSaveFile();
	g.saveName = saveName;
	//g.creationDate = Clock.currTime;
	return g;
}