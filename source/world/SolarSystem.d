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
		cereal.grain(posRad);
		cereal.grain(posAngle);
	}
 
	private:
		Star sun;
		Planet[] planets;
		ShipBase[] shipsInSystem;
		StationBase[] stationsInSystem; 

		//Position Relative to the stationary universe, may change to a galaxy later
		double posRad, posAngle;

	public:
		this(Star sun, Planet[] planets){
			this.sun = sun;
			this.planets = planets;
			systemID = randomUUID();
			posRad = uniform(1, 999);
			posAngle = uniform(0, 259);
		}
		this() {}

		nothrow double getStar() {
			return sun;
		}

		nothrow double getRadius() {
			return posRad;
		}

		nothrow double getAngle() {
			return posAngle;
		}
		
		nothrow Planet[] getPlanets() {
			return planets;
		}

		nothrow Star getSun() {
			return sun;
		}
		
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

nothrow double distanceBetween(SolarSystem a, SolarSystem b) {
	double ang = (a.getAngle() < b.getAngle()) ? b.getAngle() - a.getAngle() : a.getAngle() - b.getAngle();
	return sqrt(a.getRadius() * a.getRadius() + b.getRadius() * b.getRadius() - 2 * a.getRadius() * b.getRadius() * cos(ang));		//Law of cosines
}
