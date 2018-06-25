module ships.ShipBase;

import std.uuid;

class ShipBase {
	
	UUID shipID;

	this() {
		shipID = randomUUID();
	}

	public void tick() {
		
	}
}
