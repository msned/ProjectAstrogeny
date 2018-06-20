module render.screenComponents.ToggleSwitch;

import render.Color;
import render.screenComponents;
import render.responsiveControl;
import render.window.WindowObject;
import derelict.opengl;
import render.TextureUtil;

class RenderToggleSwitch : RenderButton, ResponsiveElement {
	
	bool toggleState = false;

	Color onColor, offColor = Colors.Blue3;

	float size;

	GLuint off, on;

	private nothrow void delegate(bool) toggles;

	this(float width, Color color, void delegate(bool) nothrow toggle, WindowObject win, bool initValue = false) {
		super(width, width, "switch_off.png", win);
		size = getWidth();
		this.onColor = color;
		setColor(offColor);
		off = LoadTexture("switch_off.png", win.windowID);
		on = LoadTexture("switch_on.png", win.windowID);
		if (initValue) {
			texture = on;
			setColor(onColor);
		}
		toggleState = initValue;
		setClick(&toggleSwitch);
		toggles = toggle;
	}

	public nothrow void setToggle(bool t) {
		toggleState = t;
		if (toggleState) {
			texture = on;
			setColor(onColor);
		} else {
			texture = off;
			setColor(offColor);
		}
	}

	private nothrow void toggleSwitch() {
		setToggle(!toggleState);
		if (toggles !is null)
			toggles(toggleState);
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
