module render.screenComponents.TypeBox;

import render.screenComponents;
import render.window.WindowObject;
import std.algorithm;
import derelict.glfw3;

class RenderTypeBox : RenderTextBox, Clickable, Inputable, Animatable {

	int lineLimit;
	int cursorIndex;
	int protectedChars;

	bool focused;
	
	this(string initialText, float width, float height, float scale, WindowObject win, int protectedChars = 0, int lineLimit = 0, bool stretchy = true) {
		super(initialText, width, height, scale, win, stretchy);
		this.lineLimit = lineLimit;
		focused = false;
		win.animationCalls ~= &animationUpdate;
		win.inputs ~= this;
		cursorIndex = protectedChars + 1;
		this.protectedChars = protectedChars;
	}

	int animationAmount = 500;
	long animationCounter;
	bool cursorOn = false;
	public nothrow void animationUpdate(long interval) {
		if (focused) {
			animationCounter += interval;
			if (animationCounter > animationAmount) {
				animationCounter = 0;
				ubyte[] text = cast(ubyte[])displayText.dup;
				if (cursorOn) {
					if (cursorIndex < displayText.length - 1)
						text = text[0 .. cursorIndex] ~ '|' ~ text[cursorIndex + 1 .. $];
					else
						text = text[0 .. cursorIndex] ~ '|';
				} else {
					if (cursorIndex < displayText.length - 1)
						text = text[0 .. cursorIndex] ~ ' ' ~ text[cursorIndex + 1 .. $];
					else
						text = text[0 .. cursorIndex] ~ ' ';
				}
				displayText = cast(string)text.idup;
				arrangeText();
				cursorOn = !cursorOn;
			}
		} else {
			if (cursorOn) {
				cursorOn = false;
				ubyte[] text = cast(ubyte[])displayText.dup;
				text = text.remove(cursorIndex);
				displayText = cast(string)text.idup;
				arrangeText();
			}
		}
	}

	protected nothrow void updateValue() {
		writelnNothrow("updated to: " ~ displayText);
	}

	protected nothrow void setFocus() {
		cursorOn = true;
		focused = true;
	}

	public override nothrow void charInput(uint c) {
		if (!focused)
			return;
		ubyte[] text = cast(ubyte[])displayText.dup;
		text = text[0 .. cursorIndex] ~ cast(ubyte)c ~ text[cursorIndex .. $];
		text[++cursorIndex] = '|';
		displayText = cast(string)text.idup;
		arrangeText();

	}

	public override nothrow void keyInput(int key, int mod) {
		if (!focused)
			return;
		switch(key) {
			case GLFW_KEY_ENTER:
				updateValue();
				break;
			case GLFW_KEY_BACKSPACE:
				if (cursorIndex <= protectedChars + 1)
					break;
				ubyte[] text = cast(ubyte[])displayText.dup;
				text = text[0 .. cursorIndex - 1] ~ text[cursorIndex .. $];
				text[--cursorIndex] = '|';
				displayText = cast(string)text.idup;
				arrangeText();
				break;
			case GLFW_KEY_LEFT:
				if (cursorIndex <= protectedChars + 1 || cursorIndex == 0)
					break;
				ubyte[] text = cast(ubyte[])displayText.dup;
				text.swapAt(cursorIndex - 1, cursorIndex);
				text[--cursorIndex] = '|';
				displayText = cast(string)text.idup;
				arrangeText();
				break;
			case GLFW_KEY_RIGHT:
				if (cursorIndex >= displayText.length - 1)
					break;
				ubyte[] text = cast(ubyte[])displayText.dup;
				text.swapAt(cursorIndex + 1, cursorIndex);
				text[++cursorIndex] = '|';
				displayText = cast(string)text.idup;
				arrangeText();
				break;
			default:
				break;
		}
	}

	public override nothrow bool isFocused() {
		return focused;
	}


	public nothrow void mouseReleased() {

	}

	public nothrow void focusLost() {
		if (focused) {
			updateValue();
			focused = false;
		}
	}

	public nothrow bool checkClick(float x, float y, int button) {
		if (within(x, y)) {
			if (button == 0 && !focused) {
				setFocus();
				return true;
			}
		}
		return false;
	}

}
