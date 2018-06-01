module render.screenComponents.ScalingIcon;

import render.screenComponents;
import render.window.WindowObject;

class RenderScalingIcon : RenderObject, ResponsiveElement {

	protected float minWidth, minHeight;

	this(float width, float height, float depth, string texture, WindowObject win) {
		super(0, 0, depth, width, height, texture, win);
		minWidth = width;
		minHeight = height;
	}

	public nothrow bool isStretchy() {return false; }

	public nothrow float getMinWidth() {
		return minWidth;
	}
	public nothrow float getMinHeight() {
		return minHeight;
	}
	
}
