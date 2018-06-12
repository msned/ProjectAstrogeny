module render.screenComponents.ToggleSwitch;

import render.Color;
import render.screenComponents;
import render.responsiveControl;
import render.window.WindowObject;
import derelict.opengl;
import render.TextureUtil;

class RenderToggleSwitch : RenderButton, ResponsiveElement {
	
	bool toggleState = false;

	float size;

	GLuint off, on;

	this(float width, Color color, WindowObject win) {
		super(width, width, "switch_off.png", win);
		size = width;
		setColor(color);
		off = LoadTexture("switch_off.png", win.windowID);
		on = LoadTexture("switch_on.png", win.windowID);
		setClick(&toggleSwitch);
	}

	public nothrow void setToggle(bool t) {
		toggleState = t;
		if (toggleState) {
			texture = on;
		} else {
			texture = off;
		}
	}

	private nothrow void toggleSwitch() {
		
	}

	public nothrow bool isStretchy() {return false; }

	public nothrow float getDefaultHeight() {
		return size;
	}
	public nothrow float getDefaultWidth() {
		return size;
	}
	public nothrow float getMinHeight() {
		return size;
	}
	public nothrow float getMinWidth() {
		return size;
	}


}
