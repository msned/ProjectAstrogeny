module render.drawing.MapBase;

import render.screenComponents;
import render.window.WindowObject;
import render.responsiveControl;

class RenderMapBase : RenderObject, ResponsiveElement {

	this(float width, float height, WindowObject win) {
		this.width = width;
		this.height = height;
	}

	public nothrow float getMinWidth() {
		return 0;
	}
	public nothrow float getDefaultWidth() {
		return width;
	}
	public nothrow float getMinHeight() {
		return 0;
	}
	public nothrow float getDefaultHeight() {
		return height;
	}
	public nothrow bool isStretchy() {
		return true;
	}
	
}
