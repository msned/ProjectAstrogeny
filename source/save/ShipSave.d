module save.ShipSave;

import ships;
import std.uuid;
import std.algorithm;

class ShipSave {

	ShipBase[] shipList;

	public void addShip(ShipBase n) {
		shipList ~= n;
	}
	public bool removeShip(UUID shipID) {
		foreach(int i, ShipBase b; shipList) {
			if (b.getID() == shipID) {
				shipList = shipList.remove(i);
				return true;
			}
		}
		return false;
	}

}