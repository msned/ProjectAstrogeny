module render.screenComponents.ContentButton;

import render.screenComponents;
import render.responsiveControl;
import render.window.WindowObject;
import render.Color;

class RenderContentButton : RenderButton, ResponsiveElement {

	protected RenderText displayText;
	protected RenderScalingIcon icon;

	int sidePadding = 10, topPadding = 10;
	Side iconSide;

	float defaultWidth, defaultHeight;

	protected float minimumFontSize = .15f;
	protected float minimumIconSize = 10f;

	this(float width, float height, Color background, string label, WindowObject win, void delegate() nothrow click = null) {
		displayText = new RenderText(label, 0, 0, 1f, win);
		super(width, height, background, win);
		defaultWidth = getWidth();
		defaultHeight = getHeight();
		if (click !is null)
			setClick(click);
	}
	this(float width, float height, Color background, string iconTexture, Side iconSide, WindowObject win) {
		icon = new RenderScalingIcon(minimumIconSize, minimumIconSize, 0f, iconTexture, win);
		super(width, height, background, win);
		defaultWidth = width;
		defaultHeight = height;
		this.iconSide = iconSide;
		justIcon = true;
	}
	this(float width, float height, Color background, string label, string iconTexture, Side iconSide, WindowObject win) {
		displayText = new RenderText(label, 0, 0, 1f, win);
		displayText.setMaxScale(width, height);

		icon = new RenderScalingIcon(minimumIconSize, minimumIconSize, 0f, iconTexture, win);
		super(width, height, background, win);
		defaultWidth = width;
		defaultHeight = height;
		this.iconSide = iconSide;
	}

	private bool justIcon = false;


	public override nothrow void setPosition(float x = 0, float y = 0) {
		super.setPosition(x, y);
		if (justIcon) {
			icon.setPosition(x, y);
		} else {
			if (displayText !is null)
				displayText.setPosition(x - ((icon !is null) ? (iconSide * (icon.getWidth() + sidePadding / 2f)) : (0)), y);		//Update logic to handle icons and text side by side
			if (icon !is null)
				icon.setPosition(x + iconSide * (displayText.getTextLength() / 2 + sidePadding / 2f), y);
		}
	}

	public override nothrow void setScale(float width, float height) {
		if (icon !is null) {
			if (width < height) {
				icon.setScale(width, width);
			} else {
				icon.setScale(height, height);
			}
		}
		if (displayText !is null) {
			if (icon !is null) {
				float sl = displayText.getMaxScale(width * 2 - sidePadding * 3 - icon.getWidth() * 2, (height * 1.5f > height * 2 - topPadding * 2) ? (height * 1.5f) : (height * 2 - topPadding * 2));
				if (sl < minimumFontSize) {
					justIcon = true;
				} else {
					justIcon = false;
					displayText.scale = sl;
				}
			} else {
				displayText.setMaxScale(width * 2 - sidePadding * 2, (height * 1.5f > height * 2 - topPadding * 2) ? (height * 1.5f) : (height * 2 - topPadding * 2));
			}
		}
		super.setScale(width, height);
	}

	public override nothrow void setScaleAndPosition(float width, float height, float x, float y) {
		setScale(width, height);
		setPosition(x, y);
	}

	public override nothrow void setDepth(float depth) {
		super.setDepth(depth);
		if (displayText !is null)
			displayText.setDepth(depth - .05f);
		if (icon !is null)
			icon.setDepth(depth - .05f);
	}

	public nothrow void setText(string s) {
		if (displayText is null)
			return;
		displayText.setText(s);
		setScale(width, height);
	}

	public nothrow bool isStretchy() {return true;}

	public nothrow float getMinWidth() {
		if (icon is null) {
			if (displayText !is null)
				return displayText.getMinWidth() / 2f + sidePadding;
		} else {
			if (displayText !is null)
				return displayText.getMinWidth() / 2f + icon.getMinWidth() + sidePadding;
			else
				return icon.getMinWidth() + sidePadding;
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

	public nothrow float getDefaultWidth() {
		return defaultWidth;
	}
	public nothrow float getDefaultHeight() {
		return defaultHeight;
	}


	public override void render() {
		if (!visible)
			return;
		super.render();
		if (icon !is null)
			icon.render();
		if (!justIcon)
			if (displayText !is null)
				displayText.render();
	}
	
}
