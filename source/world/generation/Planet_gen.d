module world.generation.Planet_gen;
import world.generation.Star_gen;
import world.Resources;
import MathConsts;
import std.random;
import std.math;

//types of atmosphere
const enum ats {Meth, CarbonDI, Oxygen};
//Types of planets
const enum planet_type {GasGiant, IceGiant, GasDwarf, Terrestrial};



/**
 * Class object that represents a planet's atmosphere
 */
class Atmosphere {

	import cerealed;

	void postBlit(C)(auto ref C cereal) {
		cereal.grain(pressure);
		cereal.grain(hydrosphereExtent);
		cereal.grain(greenhouseFactor);
		cereal.grain(albedo);
		cereal.grain(surfaceTemperature);
		cereal.grain(hydrosphere);
		cereal.grain(hasAtmos);
		cereal.grain(toxic);
		cereal.grain(atmosGases);
		cereal.grain(atmosComposition);
	}

	private:
		double pressure, hydrosphereExtent, greenhouseFactor, albedo, surfaceTemperature;
		bool hydrosphere, hasAtmos, toxic;
		Gas[] atmosGases;
		double[string] atmosComposition;
	public:
		this(double albedo){
			this.albedo = albedo;
			hydrosphere = false;
			hydrosphereExtent = 0;
			toxic = false;
			hasAtmos = true;
		}
		this() {}

		void setHydrosphere(bool val){
			hydrosphere = val;
		}

		Gas[] getGasComp(){
			return atmosGases;
		}

		double[string] getGasSize(){
			return atmosComposition;
		}

		void addGas(Gas gas, double percent){
			atmosGases ~= gas;
			atmosComposition[gas.getName()] = percent;
		}

		void setHasAtmos(bool at){
			hasAtmos = at;
		}

		void setGreenHouseFactor(double val){
			greenhouseFactor = val;
		}

		void setPressure(double pressure){
			this.pressure = pressure;
		}

		void setSurfaceTemperature(double val){
			surfaceTemperature = val;
		}
}

/**
 * Class object that represents a planet
 */
class Planet {

	import cerealed;

	void postBlit(C)(auto ref C cereal) {
		cereal.grain(mass);
		cereal.grain(density);
		cereal.grain(orbitRad);
		cereal.grain(gravAccel);
		cereal.grain(year);
		cereal.grain(escapeVelocity);
		cereal.grain(orbitAngle);
		cereal.grain(atmos);
		cereal.grain(type);
		cereal.grain(prominentRes);
		cereal.grain(traceRes);
	}

	private:
		/** mass of planet, average density, radius of planet in AU, gravity in Gs,
		 * length of full rotation in earth years, velocity in m/s, angle from sun
		 *
		 * Angle is location from top down look at solar system from the first quadrant X axis
		 */
		double mass, density, orbitRad, gravAccel, year, escapeVelocity, orbitAngle;
		Atmosphere atmos;
		planet_type type;
		min_metals[] prominentRes;
		min_metals[] traceRes;

	public:
		this(planet_type type, Atmosphere atmos, double mass, double density, double orbitRad, double gravAccel, 
			 double year, double escapeVelocity){

				this.type = type;
				this.atmos = atmos;
				this.mass = mass;
				this.density = density;
				this.orbitRad= orbitRad;
				this.gravAccel = gravAccel;
				this.year = year;
				this.escapeVelocity = escapeVelocity;
				orbitAngle = uniform(0, 359);
		}
		this() {}

		double getRadius(){
			return orbitRad;
		}

		double getAngle(){
			return orbitAngle;
		}
		
		/*
		void updateLocation(double period){
			
		}
		*/
}

/**
 * Creates an array of planets for a star
 */
Planet[] genPlanets(Star star){
	

	int numOfPlanets = uniform(1, 4);

	//Number of planets in the system
	int modPlanets;

	if(star.getType() == 'O'){
		modPlanets = cast(int)round(numOfPlanets * 0.6);			
	}
	else if(star.getType() == 'B'){
		modPlanets = cast(int)round(numOfPlanets * 0.7);
	}
	else if(star.getType() == 'A'){
		modPlanets = cast(int)round(numOfPlanets * 0.9);
	}
	else if(star.getType() == 'F'){
		modPlanets = cast(int)round(numOfPlanets * 0.9);
	}
	else if(star.getType() == 'G'){
		modPlanets = cast(int)round(numOfPlanets * 2.1);
	}
	else if(star.getType() == 'K'){
		modPlanets = cast(int)round(numOfPlanets * 2.4);			
	}
	//M or X types
	else{
		modPlanets = cast(int)round(numOfPlanets * 1.8);		
	}

	Planet[] planetArray = new Planet[modPlanets];

	for(int i = 0; i < modPlanets; i++){
		int gen = uniform(1, 10);
		if(gen == 1 || gen == 2){
			planetArray[i] = createPlanet(planetArray, star, planet_type.GasGiant);
		}
		else if(gen == 3 || gen == 4){
			planetArray[i] = createPlanet(planetArray, star, planet_type.IceGiant);
		}
		else if(gen == 5) {
			planetArray[i] = createPlanet(planetArray, star, planet_type.GasDwarf);
		}
		else{
			planetArray[i] = createPlanet(planetArray, star, planet_type.Terrestrial);
		}
	}
	return planetArray;	
}

/** Creates an orbit distance for a given planet*/
double createOrbit(Star star, planet_type type){

	double radius, min, max;
	if(type == 3){
		min = (0.2 * star.getMass()) < pow((star.getLuminosity() / 16), 0.5) ? (0.2 * star.getMass()) : pow((star.getLuminosity() / 16), 0.5);
		max = pow( (star.getLuminosity() / .04) , 0.5);
	}
	else{
		min = pow( (star.getLuminosity() / .04) , 0.5);
		max = 40.0 * star.getMass();
	}

	assert(min < max);
	radius = uniform(min, max);
	return radius;
}

//Method for creating a planet
Planet createPlanet(Planet[] array, Star star, planet_type type){
	double mass;
	double density;
	double albedo;


	switch (type){
		case planet_type.GasGiant:
			mass = uniform(0, 485) + 15.0;
			density = (uniform(5, 100) / 10.0);
			albedo = (uniform(5, 7)) / 10.0;
			break;
		case planet_type.IceGiant:
			mass = (uniform(5, 30));
			density = (uniform(1, 5));
			albedo = (uniform(5, 7)) / 10.0;
			break;
		case planet_type.GasDwarf:
			mass = (uniform(1, 15));
			density = (uniform(1, 8));
			albedo = (uniform(5, 7)) / 10.0;
			break;
		case planet_type.Terrestrial:
			mass = (uniform(5, 500)) / 100.0;
			density = (uniform(3, 8));
			albedo = (uniform(5, 50)) / 100.0;
			break;
		default:
			break;
	}

	mass = uniform(15, 500);
	density = (uniform(5, 100)) / 10.0;

	double orbitRad = 0;
	bool orbitCheck = false;

	long loopCounter = 0;

	while(!orbitCheck){
		loopCounter++;
		orbitRad = createOrbit(star, planet_type.GasGiant);
		orbitCheck = true;
		for(int i = 0; i < array.length; i++){
			if(!(array[i] is null)) {
				if(!(orbitRad > (array[i].getRadius() + .4) || orbitRad < (array[i].getRadius() - .4))){
					orbitCheck = false;
				}
			}
		}
		import std.stdio;
		if (loopCounter > 200) {
			throw new Exception("Infinite Loop Detected");
		}
	}

	double radius = pow((mass * density), 0.33);
	double gravAccel = radius * density;
	double year = pow(pow(orbitRad, 3.0) / star.getMass(), 0.5);
	double escapeVelocity = (2.365 * 0.00001) * gravAccel;

	double sunlightIntensity = star.getLuminosity() / pow(orbitRad, 2);
	Atmosphere atmos = genAtmosphere(type, albedo, sunlightIntensity, mass, star, radius);

	return new Planet(planet_type.GasGiant, atmos, mass, density, orbitRad, gravAccel, year, escapeVelocity);
}

//Method to generate an atmosphere
Atmosphere genAtmosphere(planet_type type, double albedo, double sunlightIntensity, double mass, Star star, double radius){
	double GreenhousePressure, totalATM, currATM = 0;
	int noOfTraceGases = 0;

	Atmosphere atmos = new Atmosphere(albedo);
	
	//Create Atmosphere composition
	if(type == planet_type.GasGiant || type == planet_type.GasDwarf){
		//Add helium first
		currATM = (uniform(5, 30) / 100.0);
		atmos.addGas(gases[1], currATM);
		totalATM += currATM;

		//then trace gases
		int numTrace = uniform(1, 5);
		for(int i = 0; i < numTrace; i++){
			int num = uniform(5, 18);
			atmos.addGas(gases[num], .01);
			totalATM += .01;
		}

		//Make the rest Hydrogen
		currATM = 1 - totalATM;
		atmos.addGas(gases[0], currATM);
	}
	else if(type == planet_type.IceGiant){
		//Start with helium
		currATM = uniform(10, 25) / 100.0;
		atmos.addGas(gases[1], currATM);
		totalATM += currATM;

		//Add some methane
		currATM = uniform(1, 3) / 100.0;
		atmos.addGas(gases[2], currATM);
		totalATM += currATM;

		//Then some water and ammonia

		currATM = uniform(0, 10) / 1000.0;
		atmos.addGas(gases[3], currATM);
		totalATM += currATM;

		
		currATM = uniform(0, 10) / 1000.0;
		atmos.addGas(gases[4], currATM);
		totalATM += currATM;

		//The rest is hydrogen
		currATM = 1 - totalATM;
		atmos.addGas(gases[0], currATM);
	}
	else{
		double massRatio = mass;
		//Chance a planet will have an atmosphere based on mass
		double chance = uniform(1, 10) / massRatio;
		double planetsATM = 1;

		if(chance > 10){
			atmos.setHasAtmos(false);
			atmos.setGreenHouseFactor(0);
			atmos.setPressure(0);
			double temp = star.getTemperature() * pow(((star.getRadius() * solarRad) / (2 * radius * astroUnit)), 0.5);
			double gasTemp = temp * (1 - albedo);
			atmos.setSurfaceTemperature(gasTemp);
			return atmos;
		}
		else{
			atmos.setHasAtmos(true);
			double planetsATMChance = uniform(0, 10) / 10.0;
			
			int atmosType = uniform(0, 2);

			if(atmosType == ats.Meth){
				planetsATM = planetsATMChance * 5 * massRatio;
				if(planetsATM > 5){
					planetsATM = 5;
				}
				else if(planetsATM < 0.01){
					planetsATM = 0.01;
				}

				currATM = uniform(5, 40) / 100.0;
				atmos.addGas(gases[2], currATM * planetsATM);
				totalATM += currATM;
			}
			else if(atmosType == ats.CarbonDI){
				planetsATM = planetsATMChance * 5 * massRatio;
				if(planetsATM > 200){
					planetsATM = 200;
				}
				else if(planetsATM < 0.01){
					planetsATM = 0.01;
				}

				currATM = uniform(5, 90) / 100.0;
				atmos.addGas(gases[7], currATM * planetsATM);
				totalATM += currATM;
			}
			else{
				planetsATM = planetsATMChance * 5 * massRatio;
				if(planetsATM > 5){
					planetsATM = 5;
				}
				else if(planetsATM < 0.01){
					planetsATM = 0.01;
				}

				currATM = uniform(5, 40) / 100.0;
				atmos.addGas(gases[9], currATM * planetsATM);
				totalATM += currATM;

				if(uniform(0,1) == 0){
					atmos.setHydrosphere(true);
				}
			}

			int noTrace = uniform(1, 3);
			for(int i = 0; i < noTrace; i++){
				int Trace = 0;
				int gasTrace = 0;
				while(Trace == 0){
					gasTrace = uniform(5, gases.length);		//TODO: Fix bounds?
					if(gasTrace == 6 || gasTrace == 9 || gasTrace == 12){
						Trace = 0;
					}
					else{
						Trace = 1;
					}
				}
				atmos.addGas(gases[gasTrace], .01);
				totalATM += .01;
			}

			currATM = 1- totalATM;
			atmos.addGas(gases[6], currATM * planetsATM);
		}
	}
	//Setting the temperature
	double temp = star.getTemperature() * pow(((star.getRadius() * solarRad) / (2 * radius * astroUnit)), 0.5);
	double gasTemp = temp * (1 - albedo);

	if(type != planet_type.Terrestrial){
		atmos.setSurfaceTemperature(gasTemp);
		atmos.setPressure(1);
		atmos.setGreenHouseFactor(0);
	}
	else{
		atmos.setPressure(totalATM);
		Gas[] comp = atmos.getGasComp();
		double[string] makeup =  atmos.getGasSize();

		foreach (index; comp){
			if(index.getBoilingPoint() <= gasTemp && index.isGreenH()){
				GreenhousePressure += makeup[index.getName()];
			}
		}

		double GreenHouseFactor = (totalATM / 10) + GreenhousePressure;
		double tempAdj = 374 * GreenHouseFactor * (1 - albedo) * pow(sunlightIntensity, .25);
		atmos.setSurfaceTemperature(tempAdj);
		atmos.setGreenHouseFactor(GreenHouseFactor);
	}
	return atmos;
}