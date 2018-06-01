module world.generation.SolarSystem;

import world.generation.Planet_gen;
import world.generation.Star_gen;
import std.random;
import std.math;

class AsteroidBelt{
	private:
		double minOrbitalRadius, maxOrbitalRadius;
	public:
		this(double min, double max){
			minOrbitalRadius = min;
			maxOrbitalRadius = max;
		}
}

class SolarSystem{
	private:
		Star sun;
		Planet[] planets;
		AsteroidBelt[] asteroids;
	public:
		this(Star sun, Planet[] planets, AsteroidBelt[] asteroids){
			this.sun = sun;
			this.planets = planets;
			this.asteroids = asteroids;
		}
}

/**
* Generates a solar system class
*/
SolarSystem genSolSystem(){
	Star sun = genStar();
	Planet[] planets = genPlanets(sun);

	int numBelts = uniform(1,3);
	//Mark Fix
	//double min = fmax(0.2 * sun.getMass() , (pow((sun.getLuminosity() / 16.0), 0.5))*(0.2 * sun.getMass()), (pow((sun.getLuminosity() / 16.0), 0.5)));
	double min = 0;
	double max = 40.0 * sun.getMass();

	AsteroidBelt[] asteroids = new AsteroidBelt[numBelts];
	for(int i = 0; i < numBelts; i++){
		asteroids[i] = new AsteroidBelt(min, max);
	}

	SolarSystem sys = new SolarSystem(sun, planets, asteroids);
	return sys;
}
