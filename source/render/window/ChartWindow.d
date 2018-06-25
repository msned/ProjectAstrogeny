module render.window.ChartWindow;

import render.responsiveControl;
import render.drawing.BasicChart;
import render.window.WindowObject;

class ChartWindow : WindowObject {

	this() {
		super("Chart", 640, 480);
	}

	float[] datat = [.3f, .4f, .1f, .9f, 3f, 1.75f];

	public override void loadRenderObjects() {
		FillRegion full = new FillRegion(new AnchorPercentage(-1f, Side.left), new AnchorPercentage(1f, Side.top), new AnchorPercentage(1f, Side.right), new AnchorPercentage(-1f, Side.bottom));
		regions ~= full;
		RenderBasicChart cht = new RenderBasicChart(100f, 100f, this);
		cht.setData(datat);
		full.setFill(cht);
	}
}
