module render.responsiveControl.ResponsiveRegion;


import render.screenComponents;

const enum Side {left, top, right, bottom, center};

class ResponsiveRegion {


	protected Side currentSide;

	protected RenderObject[] elements;

	this(Side sd) {
		currentSide = sd;
	}

	public void addObject(RenderObject o) {
		assert(cast(ResponsiveElement)o);
		elements ~= o;
	}

	public nothrow void renderObjects() {
		foreach (RenderObject e; elements) {
			e.render();
		}
	}

	public nothrow void updateElements(float leftBound, float topBound, float rightBound, float bottomBound) {
		switch (currentSide) {
			case Side.left:
				break;
			case Side.top:
				break;
			case Side.right:
				break;
			case Side.bottom:
				break;
			case Side.center:
				break;
			default:
				break;
		}
	}
	
}
