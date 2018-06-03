module render.screenComponents.ContentButton;

import render.screenComponents;
import render.window.WindowObject;
import render.responsiveControl;
import render.Color;

class RenderContentButton : RenderButton, ResponsiveElement {

	RenderText displayText;
	RenderScalingIcon icon;

	int sidePadding = 10, topPadding = 10;

	this(float width, float height, Color background, string label, WindowObject win) {
		displayText = new RenderText(label, 0, 0, 1f, win);
		super(width, height, background, win);
	}
	this(float width, float height, Color background, string iconTexture, int iconSide, WindowObject win) {
		icon = new RenderScalingIcon(width, height, .1f, iconTexture, win);		//TODO: logic for height and width
		super(width, height, background, win);
	}
	this(float width, float height, Color background, string label, string iconTexture, WindowObject win) {
		displayText = new RenderText(label, 0, 0, 1f, win);
		displayText.setMaxScale(width, height);

		icon = new RenderScalingIcon(width, height, .1f, iconTexture, win);		//TODO: logic for height and width

		super(width, height, background, win);
	}


	public override nothrow void setPosition(float x = 0, float y = 0) {
		super.setPosition(x, y);
		if (displayText !is null)
			displayText.setPosition(x - displayText.getTextLength(displayText.scale) / 2, y - displayText.getTextHeight() / 2);		//Update logic to handle icons and text side by side
		if (icon !is null)
			icon.setPosition(x, y);
	}

	public override nothrow void setScale(float width, float height) {
		super.setScale(width, height);
		if (displayText !is null)
			displayText.setMaxScale(width * 2 - sidePadding * 2, (height * 1.5f > height * 2 - topPadding * 2) ? (height * 1.5f) : (height * 2 - topPadding * 2));
		if (icon !is null)
			icon.setScale(width, height);		//need to update for scaling based on text size
	}

	public override nothrow void setScaleAndPosition(float width, float height, float x, float y) {
		setScale(width, height);
		setPosition(x, y);
	}

	public nothrow bool isStretchy() {return true;}

	public nothrow float getMinWidth() {
		if (icon is null) {
			if (displayText !is null)
				return displayText.getMinWidth();
		} else {
			return icon.getMinWidth();
		}
		return 0;
	}

	public nothrow float getMinHeight() {
		if (icon is null) {
			if (displayText !is null)
				return displayText.getMinHeight();
		} else {
				return icon.getMinHeight();
		}
		return 0;
	}


	public override void render() {
		super.render();
		if (icon !is null)
			icon.render();
		if (displayText !is null)
			displayText.render();
	}
	
}
