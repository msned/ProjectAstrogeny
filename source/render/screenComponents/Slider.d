module render.screenComponents.Slider;

import render.responsiveControl;
import render.screenComponents;
import render.window.WindowObject;
import render.Color;
import Settings;

class RenderSlider : RenderObject, ResponsiveElement, Draggable, Scrollable {

	private float minWidth, minHeight;

	RenderObject knob;

	float value;
	private bool currentlyDragging, vertical;
	private float defaultVal;

	private float endPadding = 10f;
	private float knobOverflow = 8f;

	nothrow void delegate(float) updateValue;

	bool stretchy = false;

	this(bool vertical, float minWidth, float minHeight, void delegate(float) nothrow updateValue, WindowObject win, float initValue = 0f, float defaultValue = 0f, bool stretchy = false) {
		this.vertical = vertical;
		this.minWidth = minWidth * GameSettings.GUIScale;
		this.minHeight = minHeight * GameSettings.GUIScale;
		this.updateValue = updateValue;
		this.defaultVal = defaultValue;
		this.stretchy = stretchy;
		this.value = initValue;
		if (vertical)
			knob = new RenderObject(getXPos(), getYPos(), 0f, minWidth + knobOverflow, 5f, "blank.png", win);
		else
			knob = new RenderObject(getXPos(), getYPos(), 0f, 5f, minHeight + knobOverflow, "blank.png", win);
		knob.setColor(Colors.Blue1);
		setColor(Colors.Blue3);
		super("blank.png", win);
		setDepth(0.1f);
		setScale(minWidth, minHeight);
	}

	private nothrow void setValue(float val) {
		value = val;
		if (value > 1f)
			value = 1f;
		if (value < 0f)
			value = 0f;
		if (vertical) {
			knob.setPosition(getXPos(), value * (height * 2 - endPadding * 2) + (getYPos() - height + endPadding));
		} else {
			knob.setPosition(value * (width * 2 - endPadding * 2) + (getXPos() - width + endPadding), getYPos());
		}
		if (updateValue !is null)
			updateValue(value);
	}

	public nothrow float getDefaultWidth() {
		return minWidth;
	}
	public nothrow float getMinWidth() {
		return minWidth;
	}
	public nothrow float getDefaultHeight() {
		return minHeight;
	}
	public nothrow float getMinHeight() {
		return minHeight;
	}

	public nothrow void mouseReleased() {
		currentlyDragging = false;
	}

	public override nothrow void setPosition(float x = 0, float y = 0) {
		super.setPosition(x, y);
		if (vertical) {
			knob.setPosition(getXPos(), value * (height * 2 - endPadding * 2) + (getYPos() - height + endPadding));
		} else {
			knob.setPosition(value * (width * 2 - endPadding * 2) + (getXPos() - width + endPadding), getYPos());
		}
	}

	public nothrow bool checkPosition(float x, float y) {
		if (!currentlyDragging)
			return false;
		if (vertical) {
			if (y <= getYPos() + height - endPadding && y >= getYPos() - height + endPadding) {
				value = ((y - (getYPos() - height + endPadding)) / (height * 2 - endPadding * 2));
				knob.setPosition(getXPos(), y);
			} else if (y < getYPos() - height + endPadding) {
				setValue(0f);
			} else if (y > getYPos() + height - endPadding) {
				setValue(1f);
			}
			if (updateValue !is null)
				updateValue(value);
		} else {
			if (x <= getXPos() + width - endPadding && x >= getXPos() - width + endPadding) {
				value = ((x - (getXPos() - width + endPadding)) / (width * 2 - endPadding * 2));
				knob.setPosition(x, getYPos());
			} else if (x < getXPos() - width + endPadding) {
				setValue(0f);
			} else if (x > getXPos() + width - endPadding) {
				setValue(1f);
			}
			if (updateValue !is null)
				updateValue(value);
		}
		return true;
	}

	public nothrow bool checkClick(float x, float y, int button) {
		if (vertical) {
			if (within(x, y, width, height - endPadding)) {
				if (button == 0) {
					currentlyDragging = true;
					return checkPosition(x, y);
				} else {
					setValue(defaultVal);
					return true;
				}
			}
		} else {
			if (within(x, y, width - endPadding, height)) {
				if (button == 0) {
					currentlyDragging = true;
					return checkPosition(x, y);
				} else if (button == 1) {
					setValue(defaultVal);
					return true;
				}
			}
		}
		return false;
	}

	float scrollDivider = 20;
	public nothrow void scroll(float x, float y, Scrollable caller = null) {
		if (vertical) {
			setValue(value + y / scrollDivider);
		} else {
			setValue(value + y / scrollDivider);
		}
	}

	bool isStretchy() {
		return stretchy;
	}

	public override void render() {
		super.render();
		knob.render();
	}
}
