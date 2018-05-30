module render.screenComponents.Button;

import render.RenderObject;
import render.screenComponents;
import render.window.WindowObject;
import std.stdio;

class RenderButton : RenderObject, Clickable {

	private nothrow void delegate() click;
	private nothrow void delegate() rClick;

	nothrow bool checkClick(float x, float y, int button) {
		if (x > this.getXPos() - this.getWidth() && x < this.getXPos() + this.getWidth() &&
			y >  this.getYPos() - this.getHeight() && y < this.getYPos() + this.getHeight()) {
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

	this(float xPos, float yPos, float depth, string texture, WindowObject win) {
		super(xPos, yPos, depth, texture, win);
		click = &defaultClick;
		rClick = &defaultRClick;
	}

	private nothrow void defaultClick() {
		try {
		writeln("button clicked!");
		} catch (Exception e){}
	}
	private nothrow void defaultRClick() {
		try {
		writeln("button right clicked!");
		} catch (Exception e){}
	}
	
}
