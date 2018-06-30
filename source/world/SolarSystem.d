module world.SolarSystem;

import world.generation.Planet_gen;
import world.generation.Star_gen;
import ships.ShipBase;
import stations.StationBase;
import std.random;
import std.math;
import std.uuid;
import cerealed;

/**
 * Class object for each system
 */
class SolarSystem{
	
	UUID systemID;

	void postBlit(C)(ref C cereal) {
		cereal.grain(sun);
		cereal.grain(planets);
		cereal.grain(shipsInSystem);
		cereal.grain(stationsInSystem);
	}
 
	private:
		Star sun;
		Planet[] planets;
		ShipBase[] shipsInSystem;
		StationBase[] stationsInSystem; 
	public:
		this(Star sun, Planet[] planets){
			this.sun = sun;
			this.planets = planets;
			systemID = randomUUID();
		}
		this() {}
		
}

/**
* Generates a solar system class
*/
SolarSystem GenSolSystem(){
	Star sun = genStar();
	Planet[] planets = genPlanets(sun);
	SolarSystem sys = new SolarSystem(sun, planets);
	return sys;
}
