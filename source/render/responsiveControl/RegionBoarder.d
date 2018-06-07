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
					anchor.updateValue(x, window.sizeX, window.sizeY);
			} else {
				setPosition(xPos, y);
				if (anchor !is null)
					anchor.updateValue(y, window.sizeX, window.sizeY);
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
			//Update Cursor
			return true;
		}
		return false;
	}

	public nothrow void mouseReleased() {
		currentlyDragging = false;
	}
	
}
