module world.generation.Planet_gen;
import world.generation.Star_gen;
import std.random;
import std.math;

/** Enum for standard atmosphereic gases*/
const enum gases {Hydrogen=0, Helium, Methane, Water, Ammonia, Neon, Nitrogen, Carbon_Monoxide, Nitrogen_Oxide, Oxygen, Hydrogen_Sulfide, Argon, Carbon_Dioxide, Nitrogen_Dioxide, Sulfur_Dioxide, Chlorine, Fluorine, Bromine, Iodine};
//enum for boiling points and greenhousefactor
const double[2][gases.max + 1] boilingPoints = [ gases.Hydrogen:[-252.879, 1], gases.Helium:[-268.9289, 0], gases.Methane:[-161.49, 1], gases.Water:[100, 1], gases.Ammonia:[-33.34, 1], gases.Neon:[-246.046, 0], gases.Nitrogen:[-195.795, 0], gases.Carbon_Monoxide:[-191.55, 1], gases.Nitrogen_Oxide:[-152, 1], gases.Oxygen:[-182.962, 0], gases.Hydrogen_Sulfide:[-60, 1], gases.Argon:[-185.848, 0], gases.Carbon_Dioxide:[-56.6, 1], gases.Nitrogen_Dioxide:[21.2, 1], gases.Sulfur_Dioxide:[-10, 1], gases.Chlorine:[-34.04, 1], gases.Fluorine:[-188.11,1], gases.Bromine:[58.8, 1], gases.Iodine:[184.32, 1]];
//types of atmosphere
const enum ats {Meth, CarbonDI, Oxygen};
//Types of planets
const enum planet_type {GasGiant, IceGiant, GasDwarf, Terrestrial};

/** Radius of sun*/
immutable double solarRad = 695700;
immutable double astroUnit = 149597870;


/**
 * Class object that represents a planet's atmosphere
 */
class Atmosphere {
	private:
		double pressure, hydrosphereExtent, greenhouseFactor, albedo, surfaceTemperature;
		bool hydrosphere, hasAtmos, toxic;
		double[gases.max + 1] atmosComposition;
	public:
		this(double albedo){
			this.albedo = albedo;
			hydrosphere = false;
			hydrosphereExtent = 0;
			toxic = false;
			hasAtmos = true;
		}

		void setHydrosphere(bool val){
			hydrosphere = val;
		}

		double[gases.max + 1] getGasComp(){
			return atmosComposition;
		}

		void addGas(int gas, double percent){
			atmosComposition[gas] = percent;
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
	private:
		/** mass of planet, average density, redius of planet in E, gravity in Gs,
		 * length of full rotation in earth years, velocity in m/s, angle from sun
		 */
		double mass, density, orbitRad, gravAccel, year, escapeVelocity;
		Atmosphere atmos;
		planet_type type;
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
		}

		double getRadius(){
			return orbitRad;
		}
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
		else if(gen == 5){
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
		min = (0.2 * star.getMass()) > pow((star.getLuminosity() / 16), 0.5) ? (0.2 * star.getMass()) : pow((star.getLuminosity() / 16), 0.5);
		max = pow( (star.getLuminosity() / .04) , 0.5);
	}
	else{
		min = pow( (star.getLuminosity() / .04) , 0.5);
		max = 40.0 * star.getMass();
	}

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
	double orbitCheck = 0;

	while(orbitCheck == 0){
		orbitRad = createOrbit(star, planet_type.GasGiant);
		orbitCheck = 1;
		for(int i = 0; i < array.length; i++){
			if(!(array[i] is null)){
				if(!(orbitRad > (array[i].getRadius() + 4) || orbitRad < (array[i].getRadius() - 4))){
					orbitCheck = 0;
				}
			}
		}
	}

	double radius = pow((mass * density), 0.33);
	double gravAccel = radius * density;
	double year = pow(pow(orbitRad, 3) / star.getMass(), 0.5);
	double escapeVelocity = (2.365 * pow(10, -5)) * gravAccel;

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
		atmos.addGas(gases.Helium, currATM);
		totalATM += currATM;

		//then trace gases
		int numTrace = uniform(1, 5);
		for(int i = 0; i < numTrace; i++){
			int num = uniform(5, 18);
			atmos.addGas(num, .01);
			totalATM += .01;
		}

		//Make the rest Hydrogen
		currATM = 1 - totalATM;
		atmos.addGas(gases.Hydrogen, currATM);
	}
	else if(type == planet_type.IceGiant){
		//Start with helium
		currATM = uniform(10, 25) / 100.0;
		atmos.addGas(gases.Helium, currATM);
		totalATM += currATM;

		//Add some methane
		currATM = uniform(1, 3) / 100.0;
		atmos.addGas(gases.Methane, currATM);
		totalATM += currATM;

		//Then some water and ammonia

		currATM = uniform(0, 10) / 1000.0;
		atmos.addGas(gases.Water, currATM);
		totalATM += currATM;

		
		currATM = uniform(0, 10) / 1000.0;
		atmos.addGas(gases.Ammonia, currATM);
		totalATM += currATM;

		//The rest is hydrogen
		currATM = 1 - totalATM;
		atmos.addGas(gases.Hydrogen, currATM);
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
				atmos.addGas(gases.Methane, currATM * planetsATM);
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
				atmos.addGas(gases.Carbon_Dioxide, currATM * planetsATM);
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
				atmos.addGas(gases.Oxygen, currATM * planetsATM);
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
					gasTrace = uniform(5, 20);
					if(gasTrace == 6 || gasTrace == 9 || gasTrace == 12){
						Trace = 0;
					}
					else{
						Trace = 1;
					}
				}
				atmos.addGas(gasTrace, .01);
				totalATM += .01;
			}

			currATM = 1- totalATM;
			atmos.addGas(gases.Nitrogen, currATM * planetsATM);
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
		double[gases.max + 1] comp = atmos.getGasComp();

		foreach (index, value; comp){
			if(boilingPoints[index][0] <= gasTemp){
				GreenhousePressure += boilingPoints[index][1] * value;
			}
		}

		double GreenHouseFactor = (totalATM / 10) + GreenhousePressure;
		double tempAdj = 374 * GreenHouseFactor * (1 - albedo) * pow(sunlightIntensity, .25);
		atmos.setSurfaceTemperature(tempAdj);
		atmos.setGreenHouseFactor(GreenHouseFactor);
	}
	return atmos;
}