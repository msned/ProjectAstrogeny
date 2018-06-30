module save.util.WorldGen;

import save.GameSave;
import save.WorldSave;
import world.SolarSystem;
import std.stdio;

const uint genNumber = 200000;

void GenerateNewWorld(WorldSave save) {
	save.systems.length = genNumber;
	for(int i = 0; i < genNumber; i++) {
		save.systems[i] = GenSolSystem();
	}
	writeln("Generated ", genNumber, " Solar Systems");
}
