module ships.OrbitalMechanics;
import world.generation.Planet_gen;
import ships.ShipBase;
import world.SolarSystem;
import std.math;

//Conversion of AU to meters
const double AuToMeters = 1.496 * pow(10,11);

class Trajectory{
	public:
		Planet sourcePlanet;
		Planet destination;
		ShipBase ship;
		double launchWindowTime;
		Path path;

		this(Planet source, Planet destination, ShipBase ship, SolarSystem sys, int typeOrbit){
			this.sourcePlanet = source;
			this.destination = destination;
			this.ship = ship;
		}
}

/**
 * Interface for all the different types of trajectories
 */
class Path{
	public:
		double timeOfTrip;
		double deltaVRequirement;		
}




