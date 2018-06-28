module render.screenComponents.Dropdown;

import render.window.WindowObject;
import render.screenComponents;
import render.Color;
import render.TextureUtil;
import render.responsiveControl;
import derelict.opengl;

class RenderDropdown : RenderContentButton {

	private bool displaying;
	GLuint up, down;
	RenderScrollList list;
	

	this(float width, float height, Color background, string label, WindowObject win, RenderScrollList scroll = null) {
		icon = new RenderScalingIcon(minimumIconSize, minimumIconSize, 0f, "down_arrow.png", win);
		icon.setColor(Colors.Blue1);
		down = LoadTexture("down_arrow.png", win.windowID);
		up = LoadTexture("up_arrow.png", win.windowID);
		if (scroll !is null)
			setList(scroll);
		super(width, height, background, label, win);
		iconSide = Side.left;
		setClick(&dropdownClicked);
		registerFocus(&focusLost);
	}

	public nothrow void setList(RenderScrollList lst) {
		list = lst;
		list.setVisible(false);
		list.setPosition(getXPos(), getYPos()  - getHeight() - list.getHeight());
		list.setScale(width, list.getHeight());
	}

	public override nothrow void setPosition(float x = 0, float y = 0) {
		super.setPosition(x, y);
		if (list !is null)
			list.setPosition(x, y  - getHeight() - list.getHeight());
	}

	public override nothrow void setScale(float width, float height) {
		if (list !is null)
			list.setScale(width, list.getHeight());
		super.setScale(width, height);
	}

	public nothrow void dropdownClicked() {
		toggleDropdown();
	}

	private nothrow void toggleDropdown() {
		displaying = !displaying;
		if (displaying) {
			icon.texture = up;
			list.setVisible(true);
		} else {
			icon.texture = down;
			list.setVisible(false);
		}
	}

	public override nothrow bool isFocused() {
		return displaying;
	}

	public override nothrow void focusLost() {
		if (skipFocus) {
			skipFocus = false;
			return;
		}
		if (displaying)
			toggleDropdown();
	}
}
