module render.screenComponents.Animatable;

interface Animatable {
	/+
	Called before every frame update with the amount of time elapsed between updates in milliseconds
	+/
	nothrow void animationUpdate(long);
}
