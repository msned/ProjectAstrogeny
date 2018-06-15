module render.screenComponents.Spacer;

import render.responsiveControl;
import render.screenComponents;
import render.window.WindowObject;

class RenderSpacer : RenderObject, ResponsiveElement {
	
	this(float width, float height) {
		setScale(width, height);
		setDepth(1f);
	}

	public override void onDestroy() {}

	public override nothrow void render() {}

	public override nothrow float getMinHeight() {
		return height;
	}
	public override nothrow float getDefaultHeight() {
		return height;
	}
	public override nothrow float getMinWidth() {
		return width;
	}
	public override nothrow float getDefaultWidth() {
		return width;
	}
	public override nothrow bool isStretchy() {return false;}
}
