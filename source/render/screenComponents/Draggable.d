module render.screenComponents.Draggable;

import render.screenComponents;

interface Draggable : Clickable {

	/*
	* Called any time the mouse position in the window changes, used to track the mouse when dragging
	*/
	nothrow bool checkPosition(float x, float y);

}
