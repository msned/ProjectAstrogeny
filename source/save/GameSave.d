module save.GameSave;

import cerealed;
import std.datetime;
import save;
import std.stdio;
import save.util.WorldGen;

class GameSave {
	
	string saveName;

	ubyte creationDay, creationMonth;
	short creationYear;

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

	GenerateNewWorld(g.world);

	g.creationDay = Clock.currTime.day;
	g.creationMonth = Clock.currTime.month;
	g.creationYear = Clock.currTime.year;

	return g;
}