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

enum AnchorType {percentage, region, ratio};

enum Side {left = -1, top = 2, right = 1, bottom = -2};

abstract class AnchorPoint {
	AnchorType type;
	bool locked;
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
			enforce(relation !is null, "Referenced region was NULL");
			if (relation.getAnchor(-assigned) !is null && relation.getAnchor(-assigned).type == AnchorType.region)
				enforce((cast(AnchorRegion)relation.getAnchor(-assigned)).reg != this, "Recursive region anchors detected");
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
			enforce(ratio > 0, "Invalid ratio value");
		}
		this.ratio = ratio;
		super(lock, assigned);
	}

	nothrow override float getPos(ResponsiveRegion r) {
		static if (DEBUG) {
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
			if ((p < -r.windowHeight / 2 || p > r.windowHeight / 2) && locked)
				r.setHidden();
			return p;
		}
	}
}

interface DragAnchor {
	nothrow RegionBoarder linkRegion(ResponsiveRegion);
	nothrow void updateValue(float value, int width, int height);
}

class DragRatio : AnchorRatio, DragAnchor {
	
	RegionBoarder board;
	ResponsiveRegion reg;

	this(float ratio, Side assigned, RegionBoarder boarder) {
		super(ratio, false, assigned);
		board = boarder;
	}

	nothrow RegionBoarder linkRegion(ResponsiveRegion r) {
		reg = r;
		return board;
	}

	nothrow void updateValue(float val, int width, int height) {
		
	}
}
class DragPercentage : AnchorPercentage, DragAnchor {

	RegionBoarder board;

	this(float percentage, Side assigned, RegionBoarder boarder) {
		super(percentage, assigned);
		board = boarder;
		board.setAnchor(this);
	}
	
	nothrow RegionBoarder linkRegion(ResponsiveRegion r) {
		return board;
	}

	nothrow void updateValue(float val, int width, int height) {
		if (assignedAnchor % 2) {	//horizontal
			percentage = val / width * 2f;
		} else {
			percentage = val / height * 2f;
		}
		board.window.setSize(width, height);
	}

}


class ResponsiveRegion {

	protected RenderObject background;
	public bool renderBackground = false;

	public int priority;
	public bool hidden;

	protected RenderObject[] elements;

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
			enforce(cast(ResponsiveElement)o, "All added objects must be of type ResponsiveElement");
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
		//sortElements();
	}
	public void clearObjects() {
		elements = [];
	}

	/++
	Sorts the RenderObject element array with highest depth first
	++/
	public void sortElements() {
		for(int i = elements.length - 1; i > 0; i--) {		//bubble sort for in-place space efficiency and best case for a mostly sorted list
			for(int j = 0; j < i; j++) {
				if (elements[j].getDepth() < elements[j+1].getDepth()) {
					RenderObject tmp = elements[j+1];
					elements[j+1] = elements[j];
					elements[j] = tmp;
				}
			}
		}
	}

	public nothrow void renderObjects() {
		if (hidden)
			return;
		if (renderBackground) {
			background.render();
			//glScissor(cast(int)abs(leftBound + windowWidth / 2f), cast(int)abs(windowHeight / 2f + bottomBound), cast(int)abs(rightBound - leftBound), cast(int)abs(topBound - bottomBound));
			//glClearColor(Colors.Golden_Dragons.red, Colors.Golden_Dragons.green, Colors.Golden_Dragons.blue, 1f);
			//glClear(GL_COLOR_BUFFER_BIT);
			//glScissor(0, 0, cast(int)windowWidth, cast(int)windowHeight);
		}
		foreach (RenderObject e; elements) {
			e.render();
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
	Scales and shifts the elements to fill the bounds given
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
