module colonies.Industry;

import colonies;
import std.math;

abstract class Industry {

	ulong employees;

	/++
	Returns the number of extra employees the industry desires to fulfill the market 
	+/
	long getExpandability();

}

class Education {

	private immutable float higherEducationPercentage = .3f;		//30% of the teaching workforce is higher education
	private immutable float higherEducationGraduationRate = .4f;	//40% estimated graduation rate
	private immutable float schoolGraduationRate = .85f;			//85% estimated graduation rate

	float higherEducationAttendanceRate = .6f;						//60% of high school graduates will attend college, influenced by industry availability and economy

	ulong students;
	ulong employees;

	private int teacherRatio = 30;	//30 students per education worker, half for higher education
	/++
	Returns the number of students over or under capacity
	+/
	long getExpandability() {
		return cast(ulong)(teacherRatio * (1f - higherEducationPercentage) + teacherRatio / 2 * higherEducationPercentage) * employees - students;
	}

	private immutable int yearsofSchool = 18, yearsofCollege = 4;

	/++
	Returns the total percentage of population leaving into the workforce, arrayed by [dropout, diploma (and not pursuing degree), degree]
	+/
	float[3] getGraduationRates(Age pop) {
		float[3] rates = [0, 0, 0];
		if (students == 0)
			return rates;
		//Calculates the amount of crowding in schools
		float depreciation = cast(float)getExpandability() / students;
		if (depreciation > -.9f || depreciation < .9f) {
			depreciation = 1f + pow(depreciation, 3) / 1.5f;
		} else if (depreciation <= -.9f) {
			depreciation = .5f;
		} else if (depreciation >= .9f) {
			depreciation = 1.5f;
		}
		float hs = pop.rangedRate(yearsofSchool - 3, yearsofSchool);
		rates[0] = (1f - schoolGraduationRate) * hs / depreciation;
		rates[1] = schoolGraduationRate * hs * depreciation * (1f - higherEducationAttendanceRate);
		rates[2] = schoolGraduationRate * higherEducationAttendanceRate * higherEducationGraduationRate * pop.rangedRate(yearsofSchool + 1, yearsofSchool + yearsofCollege);

		return rates;
	}
}

class Housing {
	
	ulong capacity;

	/++
	Returns the percentage of housing capacity filled
	+/
	float getSaturationRate(ulong population) {
		return cast(float)population / capacity;
	}
}
