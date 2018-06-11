module render.window.DebugWindow;

import render.screenComponents;
import render.window.WindowObject;
import render.responsiveControl;
import render.Color;
import std.stdio;

class DebugWindow : WindowObject {

	this() {
		super("Debug Window", 640, 960);
	}

	protected override void loadRenderObjects() {
		ResponsiveRegion left = new VerticalRegion(new AnchorPercentage(-1f, Side.left), new AnchorPercentage(1f, Side.top), new AnchorRatio(30/80f, true, Side.right), new AnchorPercentage(-1f, Side.bottom), Side.left);
		regions ~= left;
		ResponsiveRegion topRight = new VerticalGridRegion(new AnchorRegion(left, Side.left), new AnchorPercentage(1f, Side.top), new AnchorPercentage(1f, Side.right), new DragPercentage(.75f, Side.bottom, new RegionBoarder(false, this), .9f));
		regions ~= topRight;
		ResponsiveRegion right = new VerticalRegion(new AnchorRegion(left, Side.left), new AnchorRegion(topRight, Side.top), new AnchorPercentage(1f, Side.right), new AnchorPercentage(-1f, Side.bottom), Side.left);
		regions ~= right;

		RenderScrollList lst = new RenderScrollList(40f, 20f, this);
		lst.setElements([new RenderContentButton(40f, 30f, Colors.Alyx_Blue, "first", this, () {
							try {writeln("first clicked");} catch (Exception e) {}
							}), 
						 new RenderContentButton(40f, 10f, Colors.Creation, "small", this)]);
		right.addObject(new RenderDropdown(40f, 20f, Colors.Dark_Creek, "Drops", lst, this));
		right.addFixedObject(lst);

		right.addObject(new RenderScalingIcon(40f, 40f, .5f, "file_new.png", this));

		//Sort regions by decreasing priority
		left.addObject(new RenderContentButton(80, 40, Colors.Rose, "Welcome", this));
		left.addObject(new RenderContentButton(20, 20, Colors.Clues, "Test", this));
		left.addObject(new RenderContentButton(10, 10, Colors.Patina, "Edit", "file_edit.png", Side.left, this));

		topRight.addObject(new RenderSlider(true, 20, 140, (float val) {
			try {
				writeln(val);
			} catch (Exception e) {}
		}, this, .8f));


		RenderObject lefBack = new RenderObject("blank.png", this);
		lefBack.setColor(Colors.Purplez);
		lefBack.setDepth(.9f);
		left.setBackground(lefBack);
		RenderObject rightBack = new RenderObject("blank.png", this);
		rightBack.setColor(Colors.Blue);
		rightBack.setDepth(.9f);
		right.setBackground(rightBack);
		RenderObject topBack = new RenderObject("blank.png", this);
		topBack.setColor(Colors.Golden_Dragons);
		topBack.setDepth(.9f);
		topRight.setBackground(topBack);

		foreach(ResponsiveRegion r; regions)
			r.postInit(sizeX, sizeY);

		sortRegions();
	}

	private nothrow void scrollC(float val) {
		try {
			writeln(val);
		} catch (Exception e) {}
	}



	public override nothrow void characterInput(uint i) {

	}
	
}
