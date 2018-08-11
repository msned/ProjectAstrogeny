module colonies.ColonyBase;

import colonies;
import GameState;

import std.stdio;
import render.window.ChartWindow;

class ColonyBase {

	Age ages = new Age();
	Profession professions = new Profession();
	Sector sectors = new Sector();

	Industry[] industries;
	Education education = new Education();
	Housing housing = new Housing();

	/*
	Store ratio of population for each enum value, then multiply to get the total population later, multiply together with other parameters to get intersection of independent variables
	Dependent variables will require custom calculations based on the dependencies.
	Growth rate will be custom equation based on housing, economy, and housing parameters
	Struct for residences and industries to store the percentages, capacity, and other factors

	Setup struct or something for being able to chart all of this data across time.
	*/

	private int dayCounter;
	private float fertilityRateOverflow = 0;
	public void tick() {
		dayCounter++;
		if (dayCounter * GameState.daysPerTick >= 365) {
			writeln("one year");
			dayCounter = 0;
			//Student Graduations
			float[3] rates = education.getGraduationRates(ages);
			professions.shiftPopulation(Profession.Names.Student, Profession.Names.Worker, cast(ulong)(rates[0] * ages.totalPopulation), ages.totalPopulation);	//Dropouts become Workers
			professions.shiftPopulation(Profession.Names.Student, Profession.Names.Technician, cast(ulong)(rates[1] * ages.totalPopulation), ages.totalPopulation);//School graduates become Technicians
			professions.shiftPopulation(Profession.Names.Student, Profession.Names.Engineer, cast(ulong)(rates[2] * ages.totalPopulation), ages.totalPopulation);	//College graduates become Engineers
			sectors.shiftPopulation(Sector.Names.Unemployed, Sector.Names.Engineering, cast(ulong)(rates[2] * ages.totalPopulation), ages.totalPopulation); //put engineers in employment
			sectors.shiftPopulation(Sector.Names.Unemployed, Sector.Names.Manufacturing, cast(ulong)(rates[1] * ages.totalPopulation), ages.totalPopulation);//put technicians in employment
			sectors.shiftPopulation(Sector.Names.Unemployed, Sector.Names.Agriculture, cast(ulong)(rates[0] * ages.totalPopulation), ages.totalPopulation); //put workers in employment
			education.students -= cast(ulong)((rates[0] + rates[1] + rates[2]) * ages.totalPopulation);
		}

		//Adjust ages
		ages.agePopulation();
		//New Births
		float fr = getFertilityRate();
		ulong newPop = cast(ulong)((fr + fertilityRateOverflow) * ages.totalPopulation);
		if (newPop == 0) {
			fertilityRateOverflow += fr;
		} else if (newPop > 0){
			fertilityRateOverflow = 0;
			ages.addPopulation(0, newPop);
			professions.addPopulation(Profession.Names.Student, newPop, ages.totalPopulation);
			sectors.addPopulation(Sector.Names.Unemployed, newPop, ages.totalPopulation);
			education.students += newPop;
		} else {
			//Handle deaths due to fertility rate
			fertilityRateOverflow = 0;
		}


		float[] xV = new float[ages.ages.length];
		for(int i = 0; i < ages.ages.length; i++) {
			xV[i] = i;
		}
		float[] yV = new float[ages.ages.length];
		for(int i = 0; i < ages.ages.length; i++) {
			yV[i] = cast(float)ages.ages[i];
		}
		cht.setData(cast(shared)xV, cast(shared)yV);

	}
	import render.window.WindowLoop;
	import cerealed;

	@NoCereal
	ChartWindow cht;
	
	this() {
		generatePopulation();
	}

	private enum initialCount = 100000;
	private void generatePopulation() {
		ages.generateDistribution(initialCount);
		float studentRate = ages.rangedRate(0, 18);
		professions.percentages[Profession.Names.Worker] -= studentRate;
		professions.percentages[Profession.Names.Student] += studentRate;
		education.employees = 10;
		education.students = cast(ulong)(studentRate * ages.totalPopulation);
		housing.capacity = 2000;
	}

	private float maxFert = 1.4f;

	private float baseFert = .0000001f;

	/++
	Returns the growth rate per tick for the given population
	+/
	protected float getFertilityRate() {
		return baseFert * (maxFert - housing.getSaturationRate(ages.totalPopulation));
	}

}
