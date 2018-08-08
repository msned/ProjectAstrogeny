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
		shipSaveMutex.lock();
		foreach(ShipBase s; g.ships.shipList)
			s.tick();
		shipSaveMutex.unlock();
		colonySaveMutex.lock();
		foreach(ColonyBase b; g.colonies.colonies)
			b.tick();
		colonySaveMutex.unlock();
		stationSaveMutex.lock();
		foreach(StationBase s; g.stations.stations)
			s.tick();
		stationSaveMutex.unlock();

		auto endTime = MonoTime.currTime;
		Thread.sleep(threadInterval - (endTime - startTime));
	}
}
