module world.Resources;

public Gas[] gases;
public min_metals[] nat_resources;

/**
 * Interface for all in game resources
 */
abstract class Resource {
	public:
		abstract bool isEqual(Resource r);
		abstract bool sameType(Resource r);
		abstract string getName();
		abstract string getType();
}

/**
 * Atmospheric gases that are used as resources
 */
class Gas : Resource {

	import cerealed;

	
	void postBlit(C)(auto ref C cereal) {
		cereal.grain(name);
		cereal.grain(boilingPoint);
		cereal.grain(greenhouseFactor);
	}

	private:
		const string type = "gas";
		string name;
		double boilingPoint;
		bool greenhouseFactor;
	
	public:
		this(string name, double boilingPoint, bool greenhouseFactor){
			this.name = name;
			this.boilingPoint = boilingPoint;
			this.greenhouseFactor = greenhouseFactor;
		}
		this() {}
		
		override string getName(){
			return name;
		}

		override string getType(){
			return type;
		}

		bool isGreenH(){
			return greenhouseFactor;
		}

		double getBoilingPoint(){
			return boilingPoint;
		}

		override bool isEqual(Resource r){
			if(r.getName() == name){
				return true;
			}
			else{return false;}
		}

		override bool sameType(Resource r){
			if(r.getType() == type){
				return true;
			}
			else{return false;}
		}

}

/**
 * The minerals and metals that occur naturally
 */
class min_metals : Resource {

	import cerealed;

	void postBlit(C)(auto ref C cereal) {
		cereal.grain(name);
	}

	private:
		const string type = "metal";
		string name;
	public:
		this(string name){
			this.name = name;
		}
		this() {}

		override string getName(){
			return name;
		}

		override string getType(){
			return type;
		}

		override bool isEqual(Resource r){
			if(r.getName() == name){
				return true;
			}
			else{return false;}
		}

		override bool sameType(Resource r){
			if(r.getType() == type){
				return true;
			}
			else{return false;}
		}
}

/**
 * class for all player constructed materials
 */
class engineered_materials : min_metals {

	import cerealed;

	void postBlit(C)(auto ref C cereal) {
		cereal.grain(components);
		cereal.grain(makeupRates);
	}

	private:
		min_metals[] components;
		string[double] makeupRates;
		
	public:
		this(string name, min_metals[] components, string[double] makeupRates){
			super(name);
			this.components = components;
			this.makeupRates = makeupRates;
		}
		this() {}
}

/**
 * Call at beginning of game to create the resources
 */
public void InstantiateResources() {
	gases ~= new Gas("Hydrogen", -252.879, true);
	gases ~= new Gas("Helium", -268.9289, false);
	gases ~= new Gas("Methane", -161.49, true);
	gases ~= new Gas("Water", 100, true);
	gases ~= new Gas("Ammonia", -33.34, true);
	gases ~= new Gas("Neon", -246.046, false);
	gases ~= new Gas("Nitrogen", -195.795, false);
	gases ~= new Gas("Carbon_Monoxide", -191.55, true);
	gases ~= new Gas("Nitrogen_Oxide", -152, true);
	gases ~= new Gas("Oxygen", -152, false);
	gases ~= new Gas("Hydrogen_Sulfide", -60, true);
	gases ~= new Gas("Argon", -185.848, false);
	gases ~= new Gas("Carbon_Dioxide", -56.6, true);
	gases ~= new Gas("Nitrogen_Dioxide", 21.2, true);
	gases ~= new Gas("Sulfur_Dioxide", -10, true);
	gases ~= new Gas("Chlorine", -34.04, true);
	gases ~= new Gas("Fluorine", -188.11, true);
	gases ~= new Gas("Bromine", 58.8, true);
	gases ~= new Gas("Iodine", 184.32, true);

	nat_resources ~= new min_metals("Ice");
	nat_resources ~= new min_metals("Silicon");
	nat_resources ~= new min_metals("Iron");
	nat_resources ~= new min_metals("Magnesium");
	nat_resources ~= new min_metals("Carbon");
	nat_resources ~= new min_metals("Sulfur");
	nat_resources ~= new min_metals("Nickel");
	nat_resources ~= new min_metals("Aluminum");
	nat_resources ~= new min_metals("Sodium");
	nat_resources ~= new min_metals("Titanium");
	nat_resources ~= new min_metals("Phosphorus");
	nat_resources ~= new min_metals("Potassium");

	

}