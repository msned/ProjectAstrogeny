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

	this(string displayText, float width, float height, float scale, WindowObject obj, bool stretchy = true) {
		super(displayText, scale, obj);
		this.width = width * GameSettings.GUIScale;
		this.height = height * GameSettings.GUIScale;
		this.stretchy = stretchy;
		defaultHeight = height;
		defaultWidth = width;
		//setColor(Colors.Midnight_Black);
	}

	public nothrow void scroll(float x, float y) {
		
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
	public override nothrow bool isStretchy() {
		return stretchy;
	}

	float lineSpacing = 1.1;

	protected override nothrow void arrangeText() {

		vert = new GLfloat[5][6][displayText.length];
		int index = 0;
		float xOffset = 0;
		float yOffset = 0;
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
					total += Characters[c].Advance >> 6;
			}
			total *= scale;
			if (xOffset + total > width * 2 && total < width * 2) {
				yOffset += Characters['|'].ySize * scale * lineSpacing;
				xOffset = 0;
			}
			foreach(char c; s) {
				if (c == '\n') {
					yOffset += Characters['|'].ySize * scale * lineSpacing;
					xOffset = 0;
					index++;
					continue;
				}
				Character ch = Characters[c];

				if (xOffset + (ch.Advance >> 6) * scale >= width * 2) {
					yOffset += Characters['|'].ySize * scale * lineSpacing;
					xOffset = 0;
				}

				float xP = xPos + ch.xBearing * scale + xOffset;
				float yP = yPos  - (ch.ySize - ch.yBearing) * scale - yOffset;
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
		
	}

	override void render() {
		super.render();
	}
}