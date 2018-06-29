module world.Resources;

public Gas[] gases;
public min_metals[] nat_resources;

/**
 * Interface for all in game resources
 */
interface Resource {
	public:
		bool isEqual(Resource r);
		bool sameType(Resource r);
		string getName();
		string getType();
}

/**
 * Atmospheric gases that are used as resources
 */
class Gas : Resource {
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
		
		string getName(){
			return name;
		}

		string getType(){
			return type;
		}

		bool isGreenH(){
			return greenhouseFactor;
		}

		double getBoilingPoint(){
			return boilingPoint;
		}

		bool isEqual(Resource r){
			if(r.getName() == name){
				return true;
			}
			else{return false;}
		}

		bool sameType(Resource r){
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
	private:
		const string type = "metal";
		string name;
	public:
		this(string name){
			this.name = name;
		}

		string getName(){
			return name;
		}

		string getType(){
			return type;
		}

		bool isEqual(Resource r){
			if(r.getName() == name){
				return true;
			}
			else{return false;}
		}

		bool sameType(Resource r){
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
	private:
		min_metals[] components;
		string[double] makeupRates;
		
	public:
		this(string name, min_metals[] components, string[double] makeupRates){
			super(name);
			this.components = components;
			this.makeupRates = makeupRates;
		}
}

/**
 * Call at beginning of game to create the resources
 */
public void instantiateResources() {
	gases[gases.sizeof] = new Gas("Hydrogen", -252.879, true);
	gases[gases.sizeof] = new Gas("Helium", -268.9289, false);
	gases[gases.sizeof] = new Gas("Methane", -161.49, true);
	gases[gases.sizeof] = new Gas("Water", 100, true);
	gases[gases.sizeof] = new Gas("Ammonia", -33.34, true);
	gases[gases.sizeof] = new Gas("Neon", -246.046, false);
	gases[gases.sizeof] = new Gas("Nitrogen", -195.795, false);
	gases[gases.sizeof] = new Gas("Carbon_Monoxide", -191.55, true);
	gases[gases.sizeof] = new Gas("Nitrogen_Oxide", -152, true);
	gases[gases.sizeof] = new Gas("Oxygen", -152, false);
	gases[gases.sizeof] = new Gas("Hydrogen_Sulfide", -60, true);
	gases[gases.sizeof] = new Gas("Argon", -185.848, false);
	gases[gases.sizeof] = new Gas("Carbon_Dioxide", -56.6, true);
	gases[gases.sizeof] = new Gas("Nitrogen_Dioxide", 21.2, true);
	gases[gases.sizeof] = new Gas("Sulfur_Dioxide", -10, true);
	gases[gases.sizeof] = new Gas("Chlorine", -34.04, true);
	gases[gases.sizeof] = new Gas("Fluorine", -188.11, true);
	gases[gases.sizeof] = new Gas("Bromine", 58.8, true);
	gases[gases.sizeof] = new Gas("Iodine", 184.32, true);

	nat_resources[nat_resources.sizeof] = new min_metals("Ice");
	nat_resources[nat_resources.sizeof] = new min_metals("Silicon");
	nat_resources[nat_resources.sizeof] = new min_metals("Iron");
	nat_resources[nat_resources.sizeof] = new min_metals("Magnesium");
	nat_resources[nat_resources.sizeof] = new min_metals("Carbon");
	nat_resources[nat_resources.sizeof] = new min_metals("Sulfur");
	nat_resources[nat_resources.sizeof] = new min_metals("Nickel");
	nat_resources[nat_resources.sizeof] = new min_metals("Aluminum");
	nat_resources[nat_resources.sizeof] = new min_metals("Sodium");
	nat_resources[nat_resources.sizeof] = new min_metals("Titanium");
	nat_resources[nat_resources.sizeof] = new min_metals("Phosphorus");
	nat_resources[nat_resources.sizeof] = new min_metals("Potassium");

	

}