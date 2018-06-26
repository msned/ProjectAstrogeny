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
class CargoHold : ShipHold{

}

/**
*
*/
class OccupantHold : ShipHold{

}

/**
*
*/
class Sensor{

}

/**
*
*/
class armanent{

}

/**
*
*/
class lifeSupport{

}
