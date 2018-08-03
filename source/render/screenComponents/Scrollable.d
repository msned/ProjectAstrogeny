module render.screenComponents.Scrollable;

interface Scrollable {

	/*
	* Called on scroll-wheel action for x and y directions, with an optional caller object (like a scroll bar or linked regions)
	*/
	nothrow void scroll(float x, float y, Scrollable);
}
