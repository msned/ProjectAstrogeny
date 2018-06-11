module render.screenComponents.Button;

import render.screenComponents;
import render.window.WindowObject;
import render.Color;
import std.stdio;

class RenderButton : RenderObject, Clickable {

	protected nothrow void delegate() click;
	protected nothrow void delegate() rClick;

	public nothrow bool checkClick(float x, float y, int button) {
		if (within(x, y)) {
				if (button == 0) {
					if (click !is null)
						click();
				} else if (button == 1) {
					if (rClick !is null)
						rClick();
				}
				return true;
			}
		return false;
	}

	public nothrow void mouseReleased() {
		
	} 

	protected this() {}

	this(float width, float height, string texture, WindowObject win) {
		super(0, 0, .5f, width, height, texture, win);
	}
	this(float width, float height, Color col, WindowObject win) {
		this(width, height, "blank.png", win);
		setColor(col.red, col.green, col.blue);
	}

	this(float xPos, float yPos, float depth, string texture, WindowObject win) {
		super(xPos, yPos, depth, texture, win);
	}

	public void setClick(void delegate() nothrow c) {
		click = c;
	}
	public void setRClick(void delegate() nothrow rC) {
		rClick = rC;
	}
	
}
