module save.GameSave;

import cerealed;
import std.datetime;
import save;
import std.stdio;

class GameSave {
	
	string saveName;

	ubyte day, month;
	short year;

	@NoCereal
	WorldSave world;
	@NoCereal
	ShipSave ships;
	@NoCereal
	ColonySave colonies;
	@NoCereal
	StationSave stations;

	void preSerialize() {

	}
	void postSerialize() {
		writeln("loaded save ", saveName);
	}

}

GameSave NewGameSave(string saveName) {
	GameSave g = new GameSave();
	g.saveName = saveName;
	g.ships = new ShipSave();
	g.world = new WorldSave();
	g.colonies = new ColonySave();
	g.stations = new StationSave();
	g.day = Clock.currTime.day;
	g.month = Clock.currTime.month;
	g.year = Clock.currTime.year;
	return g;
}