module save.util.WorldGen;

import save.GameSave;
import save.WorldSave;
import world.SolarSystem;
import std.stdio;

enum genNumber = 200;

/++
Generates a substantial number of solar systems for testing in the current save
+/
void GenerateNewWorld(WorldSave save) {

	for(int i = 0; i < genNumber; i++) {
		SolarSystem s = GenSolSystem();
		save.systems[s.systemID] = s;
	}
	writeln("Generated ", genNumber, " Solar Systems");
}
