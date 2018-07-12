module render.responsiveControl.ResponsiveRegion;


import derelict.opengl;
import render.screenComponents;
import render.responsiveControl;
import Settings;
import std.exception;
import std.algorithm;
import std.math;
import render.Color;
import std.stdio;

enum AnchorType {percentage, region, ratio, pixel };

enum Side {left = -1, top = 2, right = 1, bottom = -2};

abstract class AnchorPoint {
	AnchorType type;
	bool locked;	//Locked determines whether the region will be hidden if the anchor point can't fit on screen
	Side assignedAnchor;
	
	this(bool lock, Side assigned) {
		locked = lock;
		assignedAnchor = assigned;
	}

	abstract nothrow float getPos(ResponsiveRegion);
}
class AnchorPercentage : AnchorPoint {
	float percentage;
	/++
	Percentage of the screen from -100% to +100% in both directions
	+/
	this(float percent, Side assigned) {
		percentage = percent;
		type = AnchorType.percentage;
		super(false, assigned);
	}
	nothrow override float getPos(ResponsiveRegion reg) {
		if (assignedAnchor % 2)
			return percentage * reg.windowWidth / 2f;
		else
			return percentage * reg.windowHeight / 2f;
	}
}
class AnchorRegion : AnchorPoint {
	ResponsiveRegion reg;

	int priority;

	this(ResponsiveRegion relation, Side assigned) {
		static if (DEBUG) {
			assert(relation !is null, "Referenced region was NULL");
			if (relation.getAnchor(-assigned) !is null && relation.getAnchor(-assigned).type == AnchorType.region)
				assert((cast(AnchorRegion)relation.getAnchor(-assigned)).reg != this, "Recursive region anchors detected");
		}
		reg = relation;
		type = AnchorType.region;
		super(false, assigned);
	}

	nothrow override float getPos(ResponsiveRegion r) {
		static if (DEBUG) {
			assert(r.priority <= reg.priority);		//Can not pull relation to a region of lower priority
		}
		return reg.getPosition(-assignedAnchor);
	}
}
class AnchorRatio : AnchorPoint {
	float ratio;

	this(float ratio, bool lock, Side assigned) {
		static if (DEBUG) {
			assert(ratio > 0, "Invalid ratio value");
		}
		this.ratio = ratio;
		type = AnchorType.ratio;
		super(lock, assigned);
	}

	nothrow override float getPos(ResponsiveRegion r) {
		static if (DEBUG) {				//No other ratios on the region
			assert(r.getAnchor(abs(assignedAnchor % 2) + 1).type != AnchorType.ratio);
			assert(r.getAnchor(-abs(assignedAnchor % 2) - 1).type != AnchorType.ratio);
			assert(r.getAnchor(-assignedAnchor).type != AnchorType.ratio);
		}
		if (assignedAnchor % 2) {	//horizontal
			float range = r.getPosition(Side.top) - r.getPosition(Side.bottom);
			range *= ratio;
			float p = r.getPosition(-assignedAnchor) + assignedAnchor * range;
			if ((p < -r.windowWidth / 2 || p > r.windowWidth / 2) && locked)
				r.setHidden();
			return p;
		} else {
			float range = r.getPosition(Side.right) - r.getPosition(Side.left);
			range *= ratio;
			float p = r.getPosition(-assignedAnchor) + assignedAnchor / 2 * range;
			if (locked && (p < -r.windowHeight / 2 || p > r.windowHeight / 2))
				r.setHidden();
			return p;
		}
	}
}
class AnchorPixel : AnchorPoint {
	
	float pixels;

	/++
	Anchors a specific number of pixels from the other side of the region
	+/
	this(float pixels, bool lock, Side assigned) {
		this.pixels = pixels * GameSettings.GUIScale;
		super(lock, assigned);
		type = AnchorType.pixel;
	}

	nothrow override float getPos(ResponsiveRegion reg) {
		static if (DEBUG) {			//Can not have opposing sides both sizing pixels
			assert(reg.getAnchor(-assignedAnchor).type != AnchorType.ratio);
		}
		if (assignedAnchor % 2) {
			float p = reg.getPosition(-assignedAnchor) + assignedAnchor * pixels;
			if (locked && (p < -reg.windowWidth / 2 || p > reg.windowWidth / 2))
				reg.setHidden();
			return p;
		} else {
			float p = reg.getPosition(-assignedAnchor) + assignedAnchor / 2 * pixels;
			if (locked && (p < -reg.windowHeight / 2 || p > reg.windowHeight / 2))
				reg.setHidden();
			return p;
		}
	}
}

interface DragAnchor {
	nothrow RegionBoarder linkRegion(ResponsiveRegion);
	nothrow bool updateValue(float value, int width, int height);
}
class DragRatio : AnchorRatio, DragAnchor {
	
	RegionBoarder board;
	ResponsiveRegion reg;
	float min;

	this(float ratio, Side assigned, RegionBoarder boarder, float minimum = float.infinity) {
		super(ratio, true, assigned);
		board = boarder;
		min = minimum;
		board.setAnchor(this);
	}

	nothrow RegionBoarder linkRegion(ResponsiveRegion r) {
		reg = r;
		return board;
	}

	nothrow bool updateValue(float val, int width, int height) {
		float rat;
		if (assignedAnchor % 2) {	//Horizontal
			if (val < -width / 2f || val > width / 2f)
				return false;
			rat = (assignedAnchor * val - assignedAnchor * reg.getPosition(-assignedAnchor)) / (reg.getPosition(Side.top) - reg.getPosition(Side.bottom));
		} else {
			if (val < -height / 2f || val > height / 2f)
				return false;
			rat = (assignedAnchor / 2 * val - assignedAnchor / 2 * reg.getPosition(-assignedAnchor)) / (reg.getPosition(Side.right) - reg.getPosition(Side.left));
		}

		if (min != float.infinity) {
			if (rat < min)
				return false;
		}
		ratio = rat;
		board.window.setSize(width, height);
		return true;
	}
}
class DragPercentage : AnchorPercentage, DragAnchor {

	RegionBoarder board;
	float min;

	this(float percentage, Side assigned, RegionBoarder boarder, float minimum = float.infinity) {
		super(percentage, assigned);
		board = boarder;
		min = minimum;
		board.setAnchor(this);
	}
	
	nothrow RegionBoarder linkRegion(ResponsiveRegion r) {
		return board;
	}

	nothrow bool updateValue(float val, int width, int height) {
		float per;
		if (assignedAnchor % 2) {	//horizontal
			if (val < -width / 2f || val > width / 2f)
				return false;
			per = val / width * 2f;
		} else {
			if (val < -height / 2f || val > height / 2f)
				return false;
			per = val / height * 2f;
		}
		if (min != float.infinity) {
			if (assignedAnchor < 0) {
				if (per > min)
					return false;
			} else if (assignedAnchor > 0) {
				if (per < min)
					return false;
			}
		}
			
		percentage = per;
		board.window.setSize(width, height);	//resize the window regions
		return true;
	}

}
class DragPixel : AnchorPixel, DragAnchor {
	
	RegionBoarder board;
	ResponsiveRegion reg;
	float min;

	this(float pixels, Side assigned, RegionBoarder boarder, float minimum = float.infinity) {
		super(pixels, false, assigned);
		board = boarder;
		min = minimum;
		board.setAnchor(this);
	}

	nothrow RegionBoarder linkRegion(ResponsiveRegion r) {
		reg = r;
		return board;
	}

	nothrow bool updateValue(float val, int width, int height) {
		if (assignedAnchor % 2) {	//Horizontal
			if (val < -width / 2f || val > width / 2f)
				return false;
		} else {
			if (val < -height / 2f || val > height / 2f)
				return false;
		}

		float pix = assignedAnchor * (val - reg.getPosition(-assignedAnchor));

		if (min != float.infinity) {
			if (assignedAnchor < 0) {
				if (pix > min)
					return false;
			} else if (assignedAnchor > 0) {
				if (pix < min)
					return false;
			}
		}

		pixels = pix;
		board.window.setSize(width, height);
		return true;
	}
}


class ResponsiveRegion {

	protected RenderObject background;
	public bool renderBackground = false;

	public int priority;
	public bool hidden;

	protected RenderObject[] elements;

	protected RenderObject[] renderElements;

	protected RenderObject[] fixedElements;

	protected AnchorPoint leftAnchor, topAnchor, rightAnchor, bottomAnchor;

	protected RegionBoarder leftB, rightB, topB, bottomB;

	public RegionBoarder[] boarders;

	this(AnchorPoint left, AnchorPoint top, AnchorPoint right, AnchorPoint bottom, int pri = 0) {
		leftAnchor = left;
		topAnchor = top;
		rightAnchor = right;
		bottomAnchor = bottom;

		priority = pri;
		elements.assumeSafeAppend();
	}

	public nothrow void postInit(float width, float height) {
		windowWidth = width;
		windowHeight = height;
		if (auto c = cast(DragAnchor)leftAnchor) {
			leftB = c.linkRegion(this);
			boarders ~= leftB;
		}
		if (auto c = cast(DragAnchor)topAnchor) {
			topB = c.linkRegion(this);
			boarders ~= topB;
		}
		if (auto c = cast(DragAnchor)rightAnchor) {
			rightB = c.linkRegion(this);
			boarders ~= rightB;
		}
		if (auto c = cast(DragAnchor)bottomAnchor) {
			bottomB = c.linkRegion(this);
			boarders ~= bottomB;
		}
		sizeBoarders();
		sortElements();
	}

	protected nothrow void sizeBoarders() {
		if (leftB !is null)
			leftB.setScaleAndPosition(5f, (getPosition(Side.top) - getPosition(Side.bottom)) / 2f, getPosition(Side.left), (getPosition(Side.top) + getPosition(Side.bottom)) / 2f);
		if (topB !is null)
			topB.setScaleAndPosition((getPosition(Side.right) - getPosition(Side.left)) / 2f, 5f, (getPosition(Side.right) + getPosition(Side.left)) / 2f, getPosition(Side.top));
		if (rightB !is null)
			rightB.setScaleAndPosition(5f, (getPosition(Side.top) - getPosition(Side.bottom)) / 2f, getPosition(Side.right), (getPosition(Side.top) + getPosition(Side.bottom)) / 2f);
		if (bottomB !is null)
			bottomB.setScaleAndPosition((getPosition(Side.right) - getPosition(Side.left)) / 2f, 5f, (getPosition(Side.right) + getPosition(Side.left)) / 2f, getPosition(Side.bottom));
	}


	nothrow AnchorPoint getAnchor(int sd) {
		switch(sd) {
			case Side.left:
				return leftAnchor;
			case Side.top:
				return topAnchor;
			case Side.right:
				return rightAnchor;
			case Side.bottom:
				return bottomAnchor;
			default:
				return null;
		}
	}

	public nothrow RenderObject[] getRenderObjects() {
		return elements;
	}
	public nothrow RenderObject[] getFixedRenderObjects() {
		return fixedElements;
	}

	public void setBackground(RenderObject o) {
		background = o;
		renderBackground = true;
	}

	float leftBound = float.infinity, topBound = float.infinity, rightBound = float.infinity, bottomBound = float.infinity;

	float windowWidth, windowHeight;

	public nothrow void clearBounds() {
		leftBound = topBound = rightBound = bottomBound = float.infinity;
	}

	protected nothrow float getPosition(Side sd) {
		switch (sd) {
			case Side.left:
				if (leftBound != float.infinity)
					return leftBound;
				else
					return leftBound = (hidden) ? rightAnchor.getPos(this) : leftAnchor.getPos(this);	//passthrough to the other side if hidden
			case Side.top:
				if (topBound != float.infinity)
					return topBound;
				else
					return topBound = (hidden) ? bottomAnchor.getPos(this) : topAnchor.getPos(this);
			case Side.right:
				if (rightBound != float.infinity)
					return rightBound;
				else
					return rightBound = (hidden) ? leftAnchor.getPos(this) : rightAnchor.getPos(this);
			case Side.bottom:
				if (bottomBound != float.infinity)
					return bottomBound;
				else
					return bottomBound = (hidden) ? topAnchor.getPos(this) : bottomAnchor.getPos(this);
			default:
				return float.nan;
		}
	}

	protected bool reUpdate;

	public nothrow void setHidden() {
		hidden = true;
		reUpdate = true;
	}
	public nothrow void clearHidden() {
		hidden = false;
	}

	/++
	Adds a RenderObject that implements ResponsiveElement
	+/
	public void addObject(RenderObject o) {
		static if (DEBUG)
			assert(cast(ResponsiveElement)o, "All added objects must be of type ResponsiveElement");
		elements ~= o;
	}

	/++
	Adds an array of RenderObjects that implement ResonsiveElement
	+/
	public void addObjects(RenderObject [] o) {
		static if (DEBUG) {
			foreach(RenderObject c; o)
				assert(cast(ResponsiveElement)c, "All added objects must be of type ResponsiveElement");
		}
		elements ~= o;
	}

	/++
	Removes the object if it exists
	+/
	public void removeObject(RenderObject o) {
		int i = countUntil(elements, o);
		if (i != -1)
			removeObject(i);
	}
	/++
	Removes the object at the index
	+/
	public void removeObject(int index) {
		elements = elements.remove(index);
	}

	public void clearObjects() {
		elements = [];
	}

	/++
	Adds a RenderObject to the fixed element list
	+/
	public void addFixedObject(RenderObject o) {
		fixedElements ~= o;
	}

	/++
	Removes the fixed Object if it exists
	+/
	public void removeFixedObject(RenderObject o) {
		int i = countUntil(fixedElements, o);
		if (i != -1)
			removeFixedObject(i);
	}

	/++
	Removes the fixed object at the index
	+/
	public void removeFixedObject(int index) {
		elements = elements.remove(index);
	}

	public void clearFixedObjects() {
		fixedElements = [];
	}

	/++
	Sorts the RenderObject element array with highest depth first
	++/
	public nothrow void sortElements() {
		renderElements.length = elements.length;
		renderElements[] = elements;
		for(int i = renderElements.length - 1; i > 0; i--) {		//bubble sort for in-place space efficiency and best case for a mostly sorted list
			for(int j = 0; j < i; j++) {
				if (renderElements[j].getDepth() < renderElements[j+1].getDepth()) {
					RenderObject tmp = renderElements[j+1];
					renderElements[j+1] = renderElements[j];
					renderElements[j] = tmp;
				}
			}
		}
	}

	public nothrow void renderObjects() {
		if (hidden)
			return;
		if (renderBackground)
			background.render();

		foreach (RenderObject e; renderElements) {
			e.render();
		}
		foreach(RenderObject o; fixedElements) {
			o.render();
		}
		if (leftB !is null)
			leftB.render();
		if (topB !is null)
			topB.render();
		if (rightB !is null)
			rightB.render();
		if (bottomB !is null)
			bottomB.render();
	}

	/++
	Scales and shifts the elements to fill the bounds given, called on window resizes, returns true on success
	+/
	public nothrow bool updateElements(float width, float height) {
		windowWidth = width;
		windowHeight = height;
		if (!hidden) {
			getPosition(Side.left);
			getPosition(Side.top);
			getPosition(Side.right);
			getPosition(Side.bottom);

			if (background !is null) {
				background.setScaleAndPosition((getPosition(Side.right) - getPosition(Side.left)) / 2f, (getPosition(Side.top) - getPosition(Side.bottom)) / 2f,
											   (getPosition(Side.right) + getPosition(Side.left)) / 2f, (getPosition(Side.top) + getPosition(Side.bottom)) / 2f);
			}
			arrangeElements();
			sizeBoarders();
		}
		if (reUpdate) {
			reUpdate = false;
			return false;
		}
		return true;
	}

	protected nothrow void arrangeElements() {
		return;
	}
	
}
