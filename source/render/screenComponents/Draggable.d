module render.screenComponents.Draggable;

import render.screenComponents;

interface Draggable : Clickable {

	nothrow bool checkPosition(float x, float y);

}
