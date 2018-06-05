module render.window.DebugWindow;

import render.screenComponents;
import render.window.WindowObject;
import render.responsiveControl;
import render.Color;

class DebugWindow : WindowObject {

	this() {
		super("Debug Window", 540, 960);
	}

	protected override void loadRenderObjects() {
		ResponsiveRegion left = new VerticalRegion(new AnchorPercentage(-1f, Side.left), new AnchorPercentage(1f, Side.top), new AnchorPercentage(30/80f, Side.right), new AnchorPercentage(-1f, Side.bottom), Side.left);
		regions ~= left;

		//Sort regions by decreasing priority
		left.addObject(new RenderContentButton(80, 40, Colors.Rose, "Welcome", this));
		left.addObject(new RenderContentButton(20, 20, Colors.Clues, "Test", this));
		left.addObject(new RenderContentButton(10, 10, Colors.Patina, "Edit", "file_edit.png", Side.left, this));
		sortRegions();
	}



	public override nothrow void characterInput(uint i) {

	}
	
}
