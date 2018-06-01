module render.window.DebugWindow;

import render.screenComponents;
import render.window.WindowObject;
import render.responsiveControl;
import render.Color;

class DebugWindow : WindowObject {

	this() {
		left = new ResponsiveRegion(Side.left);
		right = new ResponsiveRegion(Side.right);
		super("Debug Window", 540, 960);
	}

	protected override void loadRenderObjects() {
		right.addObject(new RenderContentButton(80, 40, Colors.Rose, "Welcome", this));
		sortRenderObjects();
	}



	public override nothrow void characterInput(uint i) {

	}
	
}
