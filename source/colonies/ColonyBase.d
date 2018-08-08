module colonies.ColonyBase;

import colonies;
import GameState;

import std.stdio;
import render.window.ChartWindow;

class ColonyBase {

	ulong population;

	Age ages = new Age();
	Profession professions = new Profession();
	Sector sectors = new Sector();

	Industry[] industries;
	Education education = new Education();

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
			professions.shiftPopulation(Profession.Names.Student, Profession.Names.Worker, cast(ulong)(rates[0] * population), population);	//Dropouts become Workers
			professions.shiftPopulation(Profession.Names.Student, Profession.Names.Technician, cast(ulong)(rates[1] * population), population);//School graduates become Technicians
			professions.shiftPopulation(Profession.Names.Student, Profession.Names.Engineer, cast(ulong)(rates[2] * population), population);	//College graduates become Engineers
			sectors.shiftPopulation(Sector.Names.Unemployed, Sector.Names.Engineering, cast(ulong)(rates[2] * population), population); //put engineers in employment
			sectors.shiftPopulation(Sector.Names.Unemployed, Sector.Names.Manufacturing, cast(ulong)(rates[1] * population), population);//put technicians in employment
			sectors.shiftPopulation(Sector.Names.Unemployed, Sector.Names.Agriculture, cast(ulong)(rates[0] * population), population); //put workers in employment
			education.students -= cast(ulong)((rates[0] + rates[1] + rates[2]) * population);
		}

		//Adjust ages
		ages.agePopulation();
		//New Births
		float fr = getFertilityRate();
		ulong newPop = cast(ulong)((fr + fertilityRateOverflow) * population);
		if (newPop == 0) {
			fertilityRateOverflow += fr;
		} else {
			fertilityRateOverflow = 0;
			ages.addPopulation(0, newPop, population);
			professions.addPopulation(Profession.Names.Student, newPop, population);
			sectors.addPopulation(Sector.Names.Unemployed, newPop, population);
			education.students += newPop;
			population += newPop;
		}
		float[] xV = new float[ages.percentages.length];
		for(int i = 0; i < ages.percentages.length; i++) {
			xV[i] = i;
		}
		float[] yV = ages.percentages.dup;
		for(int i = 0; i < yV.length; i++) {
			yV[i] *= population;
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

	private immutable int initialCount = 1000;
	private void generatePopulation() {
		ages.generateDistribution();
		population = initialCount;
		float studentRate = ages.rangedRate(0, 18);
		professions.percentages[Profession.Names.Worker] -= studentRate;
		professions.percentages[Profession.Names.Student] += studentRate;
		education.employees = 10;
		education.students = cast(ulong)(studentRate * population);
	}

	/++
	Returns the growth rate per tick for the given population
	+/
	protected float getFertilityRate() {
		return .00001f;
	}

}
