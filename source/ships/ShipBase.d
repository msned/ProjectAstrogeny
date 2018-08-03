module ships.ShipBase;

import std.uuid;
import world.Resources;
import TechTree.Tech;

const public int peoplePerHoldLevel = 20;
const public int cargoPerHoldLevel = 2000;

class ShipBase {
	
	public:
		//Id of ship
		string name;
		UUID shipID;

		//First double is distance, 2nd is angle from sun
		double[2] location;
		//Ship mass in kg
		int mass;
		
		
		ShipHull hull;

		ShipHold[] holds;
		//Occupancy for people and cargo
		int occupancy;
		double cargoLimit;

		passiveSensor[] passive;

		activeSensor[] active;

		Armanent[] arms;

		Engine engine;

		double deltaV;
		
		/*
		 * methods
		 */

		this() {
			shipID = randomUUID();

			deltaV = engine.exhaustVelocity * (mass / (mass - engine.propellantTotalCapacity));
		}

		void tick() {
		
		}
		UUID getID() {
			return shipID;
		}
		string getName() {
			return name;
		}
		int getOccupancy() {
			return occupancy;
		}
		double getCargoSize() {
			return cargoLimit;
		}
}

/**
 * The hull of the ship
 */
class ShipHull {
	public:
		//mass of hull
		double mass;
		//Levels for physical integrity of hull, thermal dampening
		int phsShield, thermDamp;
}

/**
* Interface for types of ship hold
*/
interface ShipHold {
	public:
		int getLevel();
		int getUnusedCapacity();
		int getOccupancy();
		int getCapacity();
}

/**
* The hold for shipping resources
*/
class CargoHold : ShipHold {
	public:
		int level;
		int capacity, occupied;
		int[Resource] cargo;

		this(int level){
			this.level = level;
			capacity = level * cargoPerHoldLevel;
		}
		
		/**
		 * Adds cargo to the hold, returns remaining amount of resource added if hold is full
		 */
		int addCargo(int amount, Resource r){
			int* p;
			p = r in cargo;
			if(p !is null){
				if(amount + occupied > capacity){
					int val = (capacity - occupied);
					*p += val;
					occupied = capacity;
					return (amount - val);
				}
				else{
					*p += amount;
					occupied += amount;
				}
			}
			else{
				if(amount + occupied > capacity){
					int val = (capacity - occupied);
					cargo[r] = val;
					occupied = capacity;
					return (amount - val);
				}
				else{
					cargo[r] = amount;
					occupied += amount;
				}				
			}
			return 0;
		}

		int getLevel(){
			return level;
		}

		int getUnusedCapacity(){
			return (capacity - occupied);
		}

		int getCapacity(){
			return capacity;
		}

		int getOccupancy(){
			return occupied;
		}
}

/**
* Holds for people dorms
*/
class OccupantHold : ShipHold {
	public:
		int level, occupied, capacity;

		this(int level){
			this.level = level;
			capacity = level * peoplePerHoldLevel;
		}

		int addPeople(int num){
			if(num + occupied > capacity){
				int val = capacity - occupied;
				occupied = capacity;
				return val;
			}
			else{
				occupied += num;
				return 0;
			}
		}	

		int getLevel(){
			return level;
		}

		int getCapacity(){
			return capacity;
		}

		int getUnusedCapacity(){
			return (capacity - occupied);
		}

		int getOccupancy(){
			return occupied;
		}
}

/**
 * gravPulse for finding ships, much farther than passive(ripple out from target)
 * Scan to determine makeup of planet(furthered by landing engineers)
 */
const enum activeSensorType {gravPulse, geo};

/**
* A sensor that projects energy to scan things 
*/
class activeSensor {
	public:
		//In AU, effectiveness modifier, extended range a Em passive sensor can pick up an echo
		double range, sensitivity, detectableRange;
		activeSensorType type;

		this(double range, double sensitivity, activeSensorType type){
			this.range = range;
			this.sensitivity = sensitivity;
			this.type = type;
			detectableRange = range * 1.2;
		}

}

/**
 * Pick up communications, colonies
 * pick up thermal signatures of stations and ships
 * Picks up pings from active
 */
const enum passiveSensorType {electrical, thermal, gravitational};

/**
* Picks up info passively, non detectable
*/
class passiveSensor {
	public:
		int sensitivity, size;
		passiveSensorType type;

		this(int sensitivity, int size, passiveSensorType type){
			this.sensitivity = sensitivity;
			this.size = size;
			this.type = type;
		}

		//Returns whether the ship detects something, with distance and strength of emission 
		bool detectable(double range, double emission){
			return false;
		}
}

/**
*
*/
class Armanent {
	public:
		this(){}
}

/**
*
*/
class LifeSupport{
	public:
		this(){}
}

/**
 * Engine for the ship
 */
class Engine{
	public:
		//unit : m/s
		double exhaustVelocity;

		double propellantPercentCapacity;
		//In kg
		double propellantTotalCapacity;

		//Type of engine tech
		engineTech type;

		this(){}
}
