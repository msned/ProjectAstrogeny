module render.window.ChartWindow;

import render.responsiveControl;
import render.drawing.BasicChart;
import render.window.WindowObject;

class ChartWindow : WindowObject {

	this() {
		super("Chart", 640, 480);
	}

	RenderBasicChart cht;

	public override void loadRenderObjects() {
		FillRegion full = new FillRegion(new AnchorPercentage(-1f, Side.left), new AnchorPercentage(1f, Side.top), new AnchorPercentage(1f, Side.right), new AnchorPercentage(-1f, Side.bottom));
		regions ~= full;
		cht = new RenderBasicChart(100f, 100f, this);
		full.setFill(cht);
	}

	public nothrow void setData(float[] datx, float [] daty) {
		cht.setData(datx, daty);
	}
}
