module colonies.Population;

import std.uuid;
import GameState;

class Age {

	ulong[] ages;
	ulong totalPopulation;

	void addPopulation(int age, ulong addedPop ) {
		ages[age] += addedPop;
	}

	private enum maxAge = 100;
	private enum daysPerYear = 365;

	float[maxAge + 1] shiftOverflow;

	//Ages up 1/365th of the population a day
	void agePopulation() {
		import std.math;
		float yearRate = 1f / daysPerYear * GameState.daysPerTick;
		ages ~= cast(ulong)(ages[$ - 1] * yearRate);
		ages[$ - 2] -= ages[$ - 1];
		for(int i = ages.length - 3; i > 0; i--) {
			//Survival Rate based on the same exponential curve used to generate
			//float survivalRate = 1f + (1f/maxAge/daysPerYear) - pow(maxAge, cast(float)(i - maxAge)/maxAge)/daysPerYear;
			float survivalRate = 1f;
			float shift = ages[i] * yearRate;
			if (shift < 1)

			ages[i + 1] += cast(ulong)(shift * survivalRate);
			ages[i] -= cast(ulong)(shift);
		}
		if (ages.length > 100)
			ages = ages[0 .. 100];

	}
	
	/++
	Integrated Distribution percentages from age1 to age2, including both bounds
	+/
	float rangedRate(int age1, int age2) {
		if (age1 >= age2)
			return 0;
		if (age1 > ages.length - 1)
			age1 = ages.length - 1;
		else if (age1 < 0) 
			age1 = 0;
		if (age2 > ages.length - 1)
			age2 = ages.length - 1;
		else if (age2 < 0) 
			age2 = 0;
		float total = 0;
		for(int i = age1; i <= age2; i++) {
			total += ages[i];
		}
		return total / totalPopulation;
	}

	/++
	Integrated Distribution percentages down to and including the age given
	+/
	float higherCumulativeRate(int age) {
		if (age < 0)
			age = 0;
		else if (age > ages.length - 1)
			age = ages.length - 1;
		float total = 0;
		for(int i = ages.length - 1; i >= age; i--) {
			total += ages[i];
		}
		return total / totalPopulation;
	}

	/++
	Integrated Distribution percentages up to and including the age given
	+/
	float lowerCumulativeRate(int age) {
		if (age > ages.length - 1)
			age = ages.length - 1;
		else if (age < 0) 
			age = 0;
		float total = 0;
		for(int i = 0; i <= age; i++) {
			total += ages[i];
		}
		return total / totalPopulation;
	}

	void generateDistribution(ulong initialCount) {
		import std.math;
		totalPopulation = 0;
		ages = [];
		ages.reserve(maxAge + 1);
		float[] percentages = [];
		float rT = 0;
		for(int i = 0; i <= maxAge; i++) {
			//Inverse Exponential function for generating a decent population distribution curve
			float v = 1f + (1f/maxAge) - pow(maxAge, cast(float)(i - maxAge)/maxAge);
			percentages ~= v;
			rT += v;
		}
		for(int i = 0; i < percentages.length; i++) {
			ages ~= cast(ulong)(round((percentages[i] / rT) * initialCount));
			totalPopulation += ages[i];
		}
	}

	private static float BinomialCoefficient(int n, int k) {
		if (k > n - k)
			k = n - k;
		float c = 1;
		for(int i = 0; i < k; i++) {
			c = c * (n - i);
			c = c / (i + 1);
		}

		return c;
	}
}

static void AddPopulation(float* percentages, int length, int index, ulong addedPop, ulong currentPopulation) {
	float rate = cast(float)(currentPopulation) / (currentPopulation + addedPop);
	for(int i = 0; i < length; i++)
		percentages[i] *= rate;
	percentages[index] += cast(float)(addedPop) / (currentPopulation + addedPop);
}

class Profession {
	enum Names {Worker, Engineer, Technician, Politician, Retired, Student};

	float[Names.max + 1] percentages;

	void addPopulation(Names pro, ulong addedPop, ulong currentPopulation) {
		AddPopulation(percentages.ptr, percentages.length, pro, addedPop, currentPopulation);
	}

	void shiftPopulation(Names from, Names to, ulong shiftedPop, ulong currentPopulation) {
		float per = shiftedPop / currentPopulation;
		percentages[from] -= per;
		percentages[to] += per;
	}

	this() {
		percentages[Names.Worker] = 1f;
	}
}

class Sector {
	enum Names {Unemployed, Agriculture, Education, Manufacturing, Engineering, Government};

	float[Names.max + 1] percentages;

	void addPopulation(Names pro, ulong addedPop, ulong currentPopulation) {
		AddPopulation(percentages.ptr, percentages.length, pro, addedPop, currentPopulation);
	}

	void shiftPopulation(Names from, Names to, ulong shiftedPop, ulong currentPopulation) {
		float per = shiftedPop / currentPopulation;
		percentages[from] -= per;
		percentages[to] += per;
	}

	this() {
		percentages[Names.Unemployed] = 1f;
	}
}
