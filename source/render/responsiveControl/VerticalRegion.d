module render.responsiveControl.VerticalRegion;

import render.responsiveControl;
import render.screenComponents;
import Settings;
import std.exception;

class VerticalRegion : ResponsiveRegion {

	Side alignment;

	this(AnchorPoint left, AnchorPoint top, AnchorPoint right, AnchorPoint bottom, Side alignment, int pri = 0) {
		super(left, top, right, bottom, pri);
		this.alignment = alignment;
		static if (DEBUG)
			enforce(alignment == Side.left || alignment == Side.right, "Alignment is only valid for left or right");
	}
	
	override protected nothrow void arrangeElements() {
		float top = getPosition(Side.top);
		float currentWidth = getPosition(Side.right) - getPosition(Side.left);
		setFittingHeights();
		foreach(RenderObject o; elements) {			//TODO: fix alignment for Right Side
			ResponsiveElement e = cast(ResponsiveElement)o;
			if (e.isStretchy()) {
				o.setScale(currentWidth / 2f, o.getHeight());
			}
			o.setPosition(o.getWidth() - alignment * getPosition(alignment), top - o.getHeight());
			top -= o.getHeight() * 2;
		}
	}

	/++
	Determines the necessary heights for resizable elements to try to fit all components on the screen of varying heights
	+/
	private nothrow void setFittingHeights() {
		float height = getPosition(Side.top) - getPosition(Side.bottom);
		RenderObject[] h = new RenderObject[elements.length];
		h[] = elements;
		for(int i = 0; i < h.length - 1; i++) { //Selection sort by difference between default and minimum height in decending order
			int choiceIndex = i;
			for(int j = i + 1; j < h.length; j++) {
				if ((cast(ResponsiveElement)h[choiceIndex]).getDifferenceHeight() < (cast(ResponsiveElement)h[j]).getDifferenceHeight())
					choiceIndex = j;
			}
			RenderObject o = h[choiceIndex];
			h[choiceIndex] = h[i];
			h[i] = o;
		}

		float minHeight = 0, defaultHeight = 0;
		foreach(RenderObject o; h) {
			auto e = cast(ResponsiveElement)o;
			minHeight += e.getMinHeight();
			defaultHeight += e.getDefaultHeight();
			o.setScale(e.getDefaultWidth(), e.getDefaultHeight());
		}

		int minIndex = h.length - 1;
		while (defaultHeight > height / 2) {
			float diff = defaultHeight - height / 2;
			float hei = diff / (minIndex + 1);
			for (int i = minIndex; i >= 0; i--) {
				if ((cast(ResponsiveElement)h[minIndex]).getDifferenceHeight() >= hei) {	//if the current lowest element has enough headroom to remove overflow for all objects
					defaultHeight -= h[i].getHeight();
					h[i].setScale(h[i].getWidth(), h[i].getHeight() - hei);
					defaultHeight += h[i].getHeight();
				} else {
					defaultHeight -= h[i].getHeight();
					h[i].setScale(h[i].getWidth(), h[i].getHeight() - (cast(ResponsiveElement)h[minIndex]).getDifferenceHeight());
					defaultHeight += h[i].getHeight();
				}
			}
			if (--minIndex < 0)
				break;
		}
	}
}
