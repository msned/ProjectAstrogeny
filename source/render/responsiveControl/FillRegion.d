module render.responsiveControl.FillRegion;

import render.responsiveControl;
import render.screenComponents;
import Settings;
import std.exception;

class FillRegion : ResponsiveRegion {
	
	RenderObject fill;

	this(AnchorPoint left, AnchorPoint top, AnchorPoint right, AnchorPoint bottom) {
		super(left, top, right, bottom);
	}

	public override void addObject(RenderObject o) {
		throw new Exception("addObject not valid for FillRegion, please use setFill instead");
	}
	public override void addObjects(RenderObject[] o) {
		throw new Exception("addObjects not valid for FillRegion, please use setFill instead");
	}

	public void setFill(RenderObject o) {
		static if (DEBUG)
			enforce(cast(ResponsiveElement)o && (cast(ResponsiveElement)o).isStretchy(), "Fill object must be of type ResponsiveElement and stretchy");
		fill = o;
		elements = [o];
	} 

	public override nothrow void arrangeElements() {
		float width = getPosition(Side.right) - getPosition(Side.left);
		float height = getPosition(Side.top) - getPosition(Side.bottom);
		float x = (getPosition(Side.right) + getPosition(Side.left)) / 2f;
		float y = (getPosition(Side.top) + getPosition(Side.bottom)) / 2f;
		fill.setScaleAndPosition(width / 2, height / 2, x, y);
	}
}
