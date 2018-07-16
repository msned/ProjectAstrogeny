module render.screenComponents.ScrollList;

import render.screenComponents;
import render.responsiveControl;
import render.window.WindowObject;
import render.Color;
import derelict.opengl;

class RenderScrollList : RenderObject, Scrollable, Clickable, ResponsiveElement {
	
	private RenderObject[] items;

	private float scrollAmount = 0;
	private float totalLength;

	private WindowObject window;
	
	this(float width, float height, WindowObject win) {
		super(0, 0, 0.06f, width, height, "blank.png", win);
		window = win;
	}

	public nothrow void setElements(RenderObject[] elements) {
		items = elements;
		shiftElements();
	}
	public nothrow RenderObject[] getElements() {
		return items;
	}

	float elementSpacing = 4f;

	private nothrow void shiftElements() {
		float dist = yPos + height + scrollAmount - elementSpacing;
		totalLength = 0;
		foreach(RenderObject o; items) {
			o.setScaleAndPosition(width, o.getHeight(), getXPos(), dist - o.getHeight());
			o.setDepth(getDepth() - .01f);
			dist -= o.getHeight() * 2 + elementSpacing;
			totalLength += o.getHeight() * 2 + elementSpacing;
		}
	}

	public override nothrow void setScale(float width, float height) {
		super.setScale(width, height);
	}
	public override nothrow void setPosition(float x = 0, float y = 0) {
		super.setPosition(x, y);
		shiftElements();
	}

	public nothrow bool isStretchy() {return true; }

	public nothrow float getMinHeight() {
		return height;
	}
	public nothrow float getDefaultHeight() {
		return height;
	}
	
	public nothrow float getMinWidth() {
		return width;
	}
	public nothrow float getDefaultWidth() {
		return width;
	}

	public nothrow void mouseReleased() {
		
	}
	public nothrow bool checkClick(float x, float y, int button) {
		if (!visible)
			return false;

		if (x < xPos + width && x > xPos - width && y < yPos + height && y > yPos - height) {
			foreach(RenderObject o; items)
				if (auto a = cast(Clickable)o)
					if (a.checkClick(x, y, button))
						return true;
		}
		return false;
	}

	Scrollable[] linkedScroll;

	private float scrollMult = 5f;
	public nothrow void scroll(float x, float y, Scrollable caller = null) {
		if (!visible)
			return;

		if (totalLength < height * 2)
			return;
		scrollAmount -= y * scrollMult;
		if (scrollAmount < 0)
			scrollAmount = 0;
		else if (scrollAmount > totalLength - height * 2)
			scrollAmount = totalLength - height * 2;
		shiftElements();

		if (linkedScroll !is null && linkedScroll.length > 0)
			try {
			foreach(Scrollable s; linkedScroll)
				if (s != caller)
					s.scroll(x, y, this);
			} catch (Exception e) { assert(0); }
	}

	public override nothrow void render() {
		if (!visible)
			return;

		window.pushScissor(cast(int)(xPos - width) + window.sizeX / 2, cast(int)(yPos - height) + window.sizeY / 2, cast(int)(width * 2), cast(int)(height * 2));
		foreach(RenderObject o; items)
			o.render();
		window.popScissor();
	}

}
