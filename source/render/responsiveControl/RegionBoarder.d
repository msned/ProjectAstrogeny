module render.responsiveControl.RegionBoarder;

import render.screenComponents;
import render.responsiveControl;
import render.window.WindowObject;
import derelict.glfw3;

class RegionBoarder : RenderObject, Draggable, Hoverable {

	private bool currentlyDragging = false;

	private bool vertical;

	private DragAnchor anchor;

	WindowObject window;


	this(bool vertical, WindowObject win) {
		super("boarder.png", win);
		this.vertical = vertical;
		this.window = win;
	}

	public void setAnchor(DragAnchor p) {
		anchor = p;
	}

	public nothrow bool checkPosition(float x, float y) {
		if (currentlyDragging) {
			if (vertical) {
				setPosition(x, yPos);
				if (anchor !is null)
					if (anchor.updateValue(x, window.sizeX, window.sizeY))
						setPosition(x, yPos);
			} else {
				if (anchor !is null)
					if (anchor.updateValue(y, window.sizeX, window.sizeY))
						setPosition(xPos, y);
			}
			return true;
		}
		return false;
	}

	public nothrow bool checkClick(float x, float y, int button) {
		if (button != 0)
			return false;
		if (checkHover(x, y)) {
			currentlyDragging = true;
			return true;
		}
		return false;
	}

	public nothrow bool checkHover(float x, float y) {
		if (within(x, y)) {
			if (window !is null) {
				if (vertical)
					window.setCursor(WindowCursor.hResize);
				else
					window.setCursor(WindowCursor.vResize);
			}
			return true;
		} else {
			if (window !is null)
				window.setCursor();
			return false;
		}
	}

	public nothrow void mouseReleased() {
		currentlyDragging = false;
	}
	
}
