module colonies.Population;

import std.uuid;
import GameState;

class Age {

	float[] percentages;

	void addPopulation(int age, ulong addedPop, ulong currentPopulation) {
		AddPopulation(percentages.ptr, percentages.length, age, addedPop, currentPopulation);
	}

	/++
	Integrated Distribution percentages up to and including the age given
	+/
	float lowerCumulativeRate(int age) {
		if (age > percentages.length - 1)
			age = percentages.length - 1;
		else if (age < 0) 
			age = 0;
		float total = 0;
		for(int i = 0; i <= age; i++) {
			total += percentages[i];
		}
		return total;
	}

	//Ages up 1/365th of the population a day, death calculations to be added later
	void agePopulation() {
		float yearRate = 1f / 365 * GameState.daysPerTick;
		percentages ~= percentages[$ - 1] * yearRate;
		percentages[$ - 2] -= percentages[$ - 1];
		for(int i = percentages.length - 3; i > 0; i--) {
			float shift = percentages[i] * yearRate;
			percentages[i + 1] += shift;
			percentages[i] -= shift;
		}
		if (percentages.length > 100)
			percentages = percentages[0 .. 100];
	}
	
	/++
	Integrated Distribution percentages from age1 to age2, including both bounds
	+/
	float rangedRate(int age1, int age2) {
		if (age1 >= age2)
			return 0;
		if (age1 > percentages.length - 1)
			age1 = percentages.length - 1;
		else if (age1 < 0) 
			age1 = 0;
		if (age2 > percentages.length - 1)
			age2 = percentages.length - 1;
		else if (age2 < 0) 
			age2 = 0;
		float total = 0;
		for(int i = age1; i <= age2; i++) {
			total += percentages[i];
		}
		return total;
	}

	/++
	Integrated Distribution percentages down to and including the age given
	+/
	float higherCumulativeRate(int age) {
		if (age < 0)
			age = 0;
		else if (age > percentages.length - 1)
			age = percentages.length - 1;
		float total = 0;
		for(int i = percentages.length - 1; i >= age; i--) {
			total += percentages[i];
		}
		return total;
	}


	immutable int generatedCount = 45;
	void generateDistribution() {
		import std.math;
		percentages.reserve(generatedCount + 1);
		float fn = pow(.5f, generatedCount);
		for(int i = 0; i <= generatedCount; i++) {
			percentages ~= BinomialCoefficient(generatedCount, i) * fn;
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
