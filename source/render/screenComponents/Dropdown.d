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
	

	this(float width, float height, Color background, string label, RenderScrollList scroll, WindowObject win) {
		icon = new RenderScalingIcon(minimumIconSize, minimumIconSize, 0f, "down_arrow.png", win);
		icon.setColor(Colors.Creation);
		down = LoadTexture("down_arrow.png", win.windowID);
		up = LoadTexture("up_arrow.png", win.windowID);
		list = scroll;
		super(width, height, background, label, win);
		iconSide = Side.left;
		list.setVisible(false);
		setClick(&toggleDropdown);
	}

	public override nothrow void setPosition(float x = 0, float y = 0) {
		super.setPosition(x, y);
		list.setPosition(x, y  - getHeight() - list.getHeight());
	}

	public override nothrow void setScale(float width, float height) {
		list.setScale(width, list.getHeight());
		super.setScale(width, height);
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

	public override void render() {
		super.render();
	}
}
