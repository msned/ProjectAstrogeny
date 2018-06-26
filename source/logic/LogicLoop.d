module logic.LogicLoop;

import GameState;
import save.GameSave;
import save.SaveData;
import core.time;
import core.thread;
import colonies;
import ships;
import stations;
import world;
import std.stdio;

const char hertz = 100;
Duration threadInterval = dur!("usecs")(1000000 / hertz);

void MainLoop() {
	while (running) {
		auto startTime = MonoTime.currTime;
		
		GameSave g = getGameSave();
		foreach(ShipBase s; g.ships.shipList)
			s.tick();
		foreach(ColonyBase b; g.colonies.colonies)
			b.tick();
		foreach(StationBase s; g.stations.stations)
			s.tick();
		gameSaveMutex.unlock();

		auto endTime = MonoTime.currTime;
		Thread.sleep(threadInterval - (endTime - startTime));
	}
}
