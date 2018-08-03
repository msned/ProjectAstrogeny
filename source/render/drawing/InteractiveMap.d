module render.drawing.InteractiveMap;

import render.drawing.MapBase;
import render.screenComponents;
import render.window.WindowObject;

class RenderInteractiveMap : RenderMapBase, Draggable, Scrollable {
	

	this(float width, float height, WindowObject win) {
		super(width, height, win);
	}

	bool currentlyDragging = false;
	float prevX, prevY;

	public override nothrow void mouseReleased() {
		currentlyDragging = false;
	}

	public override nothrow bool checkClick(float x, float y, int button) {
		if (within(x, y)) {
			foreach(RenderButton b; planetCoords) {
				if (b.checkClick(x, y, button))
					return true;
			}
			currentlyDragging = true;
			prevX = x;
			prevY = y;
			return true;
		}
		return false;
	}

	private float mouseX, mouseY;

	public override nothrow bool checkPosition(float x, float y) {
		if (currentlyDragging) {
			centerX -= x - prevX;
			centerY -= y - prevY;
			prevX = x;
			prevY = y;
			updateVertices = true;
			return true;
		}
		mouseX = x;
		mouseY = y;
		return false;
	}

	private immutable float zoomLimit = .1f;

	public override nothrow void scroll(float x, float y, Scrollable s = null) {
		import std.math;
		float oldZoom = zoomAmount;
		zoomAmount += y / 10;
		if (zoomAmount < zoomLimit)
			zoomAmount = zoomLimit;
		float mod = zoomAmount / oldZoom - 1f;
		float dx = (mouseX - xPos + centerX) * mod;	//TODO: fix the scaling
		float dy = (mouseY - yPos + centerY) * mod;

		centerX += dx;
		centerY += dy;
		updateVertices = true;
	}


}
