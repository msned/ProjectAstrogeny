module render.screenComponents.Clickable;

interface Clickable {

	/*
	* Called on a mouse click in the current window, return true on first object to process the click
	*/
	nothrow bool checkClick(float x, float y, int button);

	/*
	* Called when the mouse is released from a click
	*/
	nothrow void mouseReleased();
}
