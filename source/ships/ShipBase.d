module ships.ShipBase;

import std.uuid;

class ShipBase {
	
	private:
		string name;
		UUID shipID;
	
	public:
		this() {
			shipID = randomUUID();
		}

		void tick() {
		
		}
		UUID getID() {
			return shipID;
		}
		string getName() {
			return name;
		}
}

/**
 *
 */
class ShipHull {

}

/**
*
*/
class ShipHold {

}

/**
*
*/
class CargoHold : ShipHold {

}

/**
*
*/
class OccupantHold : ShipHold {

}

/**
*
*/
class Sensor {

}

/**
*
*/
class Armanent {

}

/**
*
*/
class LifeSupport{

}
