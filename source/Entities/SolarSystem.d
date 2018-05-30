module SolarSystem;

import generation.Planet_gen;
import Star_gen;
import std.rnd;

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
	double min = fmax((0.2 * sun.getMass()) , (pow((sun.getLuminosity() / 16.0), 0.5))(0.2 * sun.getMass()) , (pow((sun.getLuminosity() / 16.0), 0.5)));
	double max = 40.0 * sun.getMass();

	AsteroidBelts[] asteroids = new AsteroidBelts[numBelts];
	for(int i = 0; i < numBelts; i++){
		asteroids[i] = new AstroidBelt(min, max);
	}

	SolarSystem sys = new SolarSystem(sun, planets, asteroids);
	return sys;
}
