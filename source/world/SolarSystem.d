module world.SolarSystem;

import world.generation.Planet_gen;
import world.generation.Star_gen;
import std.random;
import std.math;

/**
 * Class object for each system
 */
class SolarSystem{
	private:
		Star sun;
		Planet[] planets;
	public:
		this(Star sun, Planet[] planets){
			this.sun = sun;
			this.planets = planets;
		}
}

/**
* Generates a solar system class
*/
SolarSystem genSolSystem(){
	Star sun = genStar();
	Planet[] planets = genPlanets(sun);
	SolarSystem sys = new SolarSystem(sun, planets);
	return sys;
}
