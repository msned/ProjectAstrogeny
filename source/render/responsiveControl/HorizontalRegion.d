module render.responsiveControl.HorizontalRegion;

import render.responsiveControl;
import render.screenComponents;
import std.exception;
import Settings;

class HorizontalRegion : ResponsiveRegion {

	Side alignment;

	this (AnchorPoint left, AnchorPoint top, AnchorPoint right, AnchorPoint bottom, Side alignment, int pri = 0) {
		static if (DEBUG)
			enforce(alignment == Side.top || alignment == Side.bottom, "Alignment is only valid for top or bottom");
		super(left, top, right, bottom, pri);
		this.alignment = alignment;
	}
	this(HorizontalRegion reg) {
		this(reg.getAnchor(Side.left), reg.getAnchor(Side.top), reg.getAnchor(Side.right), reg.getAnchor(Side.bottom), reg.alignment, reg.priority);
	}

	float spacing = 2f;

	protected override nothrow void arrangeElements() {
		float width = getPosition(Side.right) - getPosition(Side.left);
		float height = getPosition(Side.top) - getPosition(Side.bottom);
		float total = 0;
		foreach(RenderObject o; elements)
			total += o.getWidth() * 2;
		if (total <= width) {	//fill from the left
			total = getPosition(Side.left);
			foreach(RenderObject o; elements) {
				if ((cast(ResponsiveElement)o).isStretchy())
					o.setScaleAndPosition(o.getWidth(), height / 2f, total + o.getWidth(), getPosition(alignment) - (alignment / 2f) * (height / 2f));
				else
					o.setPosition(total + o.getWidth(), getPosition(alignment) - (alignment / 2f * o.getHeight()));
				total += o.getWidth() * 2 + spacing;
			}
		} else {				//fill the whole region 
			RenderObject[] h;
			h.length = elements.length;
			h[] = elements;
			for(int i = 0; i < h.length - 1; i++) { //Selection sort by difference between default and minimum width in decending order
				int choiceIndex = i;
				for(int j = i + 1; j < h.length; j++) {
					if ((cast(ResponsiveElement)h[choiceIndex]).getDifferenceWidth() < (cast(ResponsiveElement)h[j]).getDifferenceWidth())
						choiceIndex = j;
				}
				RenderObject o = h[choiceIndex];
				h[choiceIndex] = h[i];
				h[i] = o;
			}

			float minWidth = 0, defaultWidth = 0;
			foreach(RenderObject o; h) {
				auto e = cast(ResponsiveElement)o;
				minWidth += e.getMinWidth();
				defaultWidth += e.getDefaultWidth();
				o.setScale(e.getDefaultWidth(), e.getDefaultHeight());
			}

			int minIndex = h.length - 1;
			while (defaultWidth > width / 2) {
				float diff = defaultWidth - width / 2;
				float wid = diff / (minIndex + 1);
				for(int i = minIndex; i >= 0; i--) {
					if ((cast(ResponsiveElement)h[minIndex]).getDifferenceWidth() >= wid) {
						defaultWidth -= h[i].getWidth();
						h[i].setScale(h[i].getWidth() - wid, h[i].getHeight());
						defaultWidth += h[i].getWidth();
					} else {
						defaultWidth -= h[i].getWidth();
						h[i].setScale(h[i].getWidth() - (cast(ResponsiveElement)h[minIndex]).getDifferenceWidth(), h[i].getHeight());
						defaultWidth += h[i].getWidth();
					}
				}
				if (--minIndex < 0)
					break;
			}

		}
	}
}
