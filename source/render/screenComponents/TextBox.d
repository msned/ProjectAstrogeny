module render.screenComponents.TextBox;

import render.screenComponents;
import render.window.WindowObject;
import derelict.opengl;
import Settings;
import render.Fonts;
import std.array;
import render.Color;

class RenderTextBox : RenderText, Scrollable {

	float defaultWidth, defaultHeight;
	bool stretchy;
	float scrollAmount = 0, textLength;
	private WindowObject window;
	bool lockScroll;
	int lineLimit;

	RenderObject background;

	this(string displayText, float width, float height, float scale, WindowObject obj, int lineLimit = 0, bool stretchy = true) {
		super(displayText, scale, obj);
		this.width = width * GameSettings.GUIScale;
		this.height = height * GameSettings.GUIScale;
		this.stretchy = stretchy;
		this.lineLimit = lineLimit;
		window = obj;
		defaultHeight = height;
		defaultWidth = width;
	}

	public void setBackground(Color c) {
		background = new RenderObject(xPos, yPos, .9f, width, height, "blank.png", window);
		background.setColor(c);
	}


	private float scrollMult = 5f;
	public nothrow void scroll(float x, float y, Scrollable caller = null) {
		if (!visible || lockScroll)
			return;
		scrollAmount += y * scrollMult;
		if (scrollAmount < -(textLength - height * 2))
			scrollAmount = -textLength + height * 2;
		else if (scrollAmount > 0)
			scrollAmount = 0;
		arrangeText();
	}

	public override nothrow float getWidth() {
		return width;
	}
	public override nothrow float getHeight() {
		return height;
	}
	public override nothrow float getMinWidth() {
		return 0;
	}
	public override nothrow float getMinHeight() {
		return 0;
	}
	public override nothrow float getDefaultHeight() {
		return defaultHeight;
	}
	public override nothrow float getDefaultWidth() {
		return defaultWidth;
	}
	public override nothrow void setPosition(float x = 0, float y = 0) {
		xPos = x;
		yPos = y;
		newArray = true;
		if (background !is null)
			background.setPosition(x, y);
	}
	public override nothrow void setScale(float width, float height) {
		if (background !is null)
			background.setScale(width, height);
		super.setScale(width, height);
	}
	public override nothrow void setScaleAndPosition(float width, float height, float x, float y) {
		xPos = x;
		yPos = y;
		if (background !is null)
			background.setPosition(x, y);
		setScale(width, height);
	}

	public override nothrow bool isStretchy() {
		return stretchy;
	}

	float lineSpacing = 1.1;

	const static string nextLine = "
		yOffset += Characters[windowID]['|'].ySize * scale * lineSpacing;
		xOffset = 0;
		if (lineLimit && ++line > lineLimit)
			return false;
		";

	protected override nothrow bool arrangeText() {

		vert = new GLfloat[5][6][displayText.length];
		int index = 0;
		int line = 1;
		float xOffset = 0;
		float yOffset = scrollAmount;
		string[] words;

		try {
			words = displayText.split(' ');
		} catch (Exception e) {
			writelnNothrow("Error with TextBox formatting");
		}
		foreach(int i, string s; words) {
			if (i != words.length - 1)
				s ~= ' ';
			float total = 0;
			foreach(char c; s) {
				if (c != '\n')
					total += Characters[windowID][c].Advance >> 6;
			}
			total *= scale;
			if (xOffset + total > width * 2 && total < width * 2) {
				mixin(nextLine);
			}
			foreach(char c; s) {
				if (c == '\n') {
					mixin(nextLine);
					index++;
					continue;
				}
				Character ch = Characters[windowID][c];

				if (xOffset + (ch.Advance >> 6) * scale >= width * 2) {
					mixin(nextLine);
				}

				float xP = xPos + ch.xBearing * scale + xOffset - width;
				float yP = yPos - (ch.ySize - ch.yBearing) * scale - yOffset + height - Characters[windowID]['|'].ySize * scale;
				float w = ch.xSize * scale;
				float h = ch.ySize * scale;


				vert[index++] = [
					[xP, yP+h, depth,		0.0, 0.0],
					[xP, yP, depth,		0.0, 1.0],
					[xP+w, yP, depth,		1.0, 1.0],

					[xP, yP+h, depth,		0.0, 0.0],
					[xP+w, yP, depth,		1.0, 1.0],
					[xP+w, yP+h, depth,	1.0, 0.0]
				];

				xOffset += (ch.Advance >> 6) * scale;
			}
		}
		textLength = yOffset + Characters[windowID]['|'].ySize * scale * lineSpacing - scrollAmount;
		return true;
	}

	override void render() {
		if (!visible)
			return;

		if (background !is null)
			background.render();

		window.pushScissor(cast(int)(xPos - width) + window.sizeX / 2, cast(int)(yPos - height) + window.sizeY / 2, cast(int)(width * 2), cast(int)(height * 2));
		super.render();
		window.popScissor();
	}
}
