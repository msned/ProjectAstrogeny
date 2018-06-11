module render.screenComponents.Slider;

import render.responsiveControl;
import render.screenComponents;
import render.window.WindowObject;
import render.Color;

class RenderSlider : RenderObject, ResponsiveElement, Draggable, Scrollable {

	private float minWidth, minHeight;

	RenderObject knob;

	float value;
	private bool currentlyDragging, vertical;

	float endPadding = 10f;

	nothrow void function(float) updateValue;

	this(bool vertical, float minWidth, float minHeight, void function(float) nothrow updateValue, WindowObject win, float initValue = 0f) {
		this.vertical = vertical;
		this.minWidth = minWidth;
		this.minHeight = minHeight;
		this.updateValue = updateValue;
		super("blank.png", win);
		setDepth(0.1f);
		setScale(minWidth, minHeight);
		knob = new RenderObject(getXPos(), getYPos(), 0f, 10, 10, "blank.png", win);
		knob.setColor(Colors.Rose);
		setValue(initValue);
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
			updateValue(val);
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
				currentlyDragging = true;
				return checkPosition(x, y);
			}
		} else {
			if (within(x, y, width - endPadding, height)) {
				currentlyDragging = true;
				return checkPosition(x, y);
			}
		}
		return false;
	}

	float scrollDivider = 20;
	public nothrow void scroll(float x, float y) {
		if (vertical) {
			setValue(value + y / scrollDivider);
		}
		else {
			setValue(value + x / scrollDivider);
		}
	}

	bool isStretchy() {
		return false;
	}

	public override void render() {
		super.render();
		knob.render();
	}
}
