module render.responsiveControl.VerticalGridRegion;

import render.responsiveControl;
import render.screenComponents;
import std.exception;

class VerticalGridRegion : ResponsiveRegion {

	this(AnchorPoint left, AnchorPoint top, AnchorPoint right, AnchorPoint bottom, int pri = 0) {
		super(left, top, right, bottom, pri);
	}

	override protected nothrow void arrangeElements() {
		float height = getPosition(Side.top);
		foreach(RenderObject o; elements) {
			ResponsiveElement e = cast(ResponsiveElement)o;
			//TODO: add grid layout
		}
	}
}
