module world.generation.Star_gen;
import std.stdio;

/** Enum for the different classifications of star*/
enum star_types {O, B, A, F, G, K, X, M};

class Star {

	import cerealed;

	void postBlit(C)(auto ref C cereal) {
		cereal.grain(type);
		cereal.grain(radius);
		cereal.grain(temperature);
		cereal.grain(mass);
		cereal.grain(luminosity);
	}

	private:
		/** Type of star*/
		star_types type;

		/** Star measurement in sol Radii, K, solar mass, solar luminosity*/
		double radius, temperature, mass, luminosity;
	public:
		/** Constructor for star*/
		this(star_types type, double radius, double temperature, double mass, double luminosity){
			this.type = type;
			this.radius = radius;
			this.temperature = temperature;
			this.mass = mass;
			this.luminosity = luminosity;
		}

		this() {}

		star_types getType(){
			return type;
		}

		double getRadius(){
			return radius;
		}

		double getTemperature(){
			return temperature;
		}

		double getMass(){
			return mass;
		}

		double getLuminosity(){
			return luminosity;
		}
}

/**
 * Generates a random star
 */
Star genStar(){
	import std.random;
	import std.math;
	immutable double bolometricConstant = .2632;
	immutable double solTemp = 5770;


	int num = uniform(1, 100000);
	star_types type;
	double radius, temperature, mass, luminosity;

	if(num >= 0 && num <= 3){
		type = star_types.O;
		temperature = uniform(0, 18000) + 30000.0;
		luminosity = uniform(0, 970000) + 30000.0;
	}
	else if(num >= 4 && num <= 134){
		type = star_types.B;
		temperature = uniform(0, 20000) + 10000.0;
		luminosity = uniform(0, 29975) + 25.0;
	}
	else if(num >= 135 && num <= 735){
		type = star_types.A;
		temperature = uniform(0, 2500) + 7500.0;
		luminosity = uniform(0, 20) + 5.0;
	}
	else if(num >= 736 && num <= 3736){
		type = star_types.F;
		temperature = uniform(0, 1500) + 6000.0;
		luminosity = (uniform(0, 35) + 15.0) / 10.0;
	}
	else if(num >= 3737 && num <= 11337){
		type = star_types.G;
		temperature = uniform(0, 800) + 5200.0;
		luminosity = (uniform(0, 10) + 5.0) / 10.0;
	}
	else if(num >= 11338 && num <= 23438){
		type = star_types.K;
		temperature = uniform(0, 1500) + 3700.0;
		luminosity = (uniform(8, 60)) / 100.0;
	}
	else{
		type = star_types.M;
		temperature = uniform(0, 1300) + 2400.0;
		luminosity = (uniform(0, 6) + 2.0) / 100.0;
	}

	radius = (pow(solTemp, 2) / pow(temperature, 2)) * sqrt(luminosity);
	mass = pow(luminosity, bolometricConstant);

	return new Star(type, radius, temperature, mass, luminosity);
}