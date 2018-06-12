module render.window.SettingsWindow;

import render.screenComponents;
import render.responsiveControl;
import render.window.WindowObject;
import render.Color;

class SettingsWindow : WindowObject {
	
	this() {
		super("Settings");
	}

	protected override void loadRenderObjects() {
		ResponsiveRegion tabs = new HorizontalRegion(new AnchorPercentage(-1f, Side.left), new AnchorPercentage(1f, Side.top), new AnchorPercentage(1f, Side.right), new AnchorPixel(30f, true, Side.bottom), Side.bottom, 1);
		regions ~= tabs;
		
		VerticalRegion valueGraphics = new VerticalRegion(new AnchorPercentage(.7f, Side.left), new AnchorRegion(tabs, Side.top), new AnchorPercentage(1f, Side.right), new AnchorPercentage(-1f, Side.bottom), Side.right);
		VerticalRegion valueAudio = new VerticalRegion(valueGraphics);
		VerticalRegion valueControls = new VerticalRegion(valueGraphics);
		TabRegion tabValues = new TabRegion([valueGraphics, valueAudio, valueControls]);
		regions ~= tabValues;

		VerticalRegion labelGraphics = new VerticalRegion(new AnchorPercentage(-1f, Side.left), new AnchorRegion(tabs, Side.top), new AnchorRegion(valueGraphics, Side.right), new AnchorPercentage(-1f, Side.bottom), Side.left);
		VerticalRegion labelAudio = new VerticalRegion(labelGraphics);
		VerticalRegion labelControls = new VerticalRegion(labelGraphics);
		TabRegion tabLabels = new TabRegion([labelGraphics, labelAudio, labelControls]);
		regions ~= tabLabels;

		tabs.addObjects(cast(RenderObject[])tabLabels.setupTabButtons(tabValues.setupTabButtons([new RenderContentButton(60, 50, Colors.Clues, "Graphics", this), new RenderContentButton(60, 30, Colors.Rose, "Audio", this), new RenderContentButton(50, 30, Colors.Alyx_Blue, "Controls", this)])));

		RenderObject valueBack = new RenderObject("blank.png", this);
		valueBack.setColor(Colors.Dark_Creek);
		valueBack.setDepth(.9f);
		valueGraphics.setBackground(valueBack);
		RenderObject labelBack = new RenderObject("blank.png", this);
		labelBack.setColor(Colors.Purplez);
		labelBack.setDepth(.9f);
		labelAudio.setBackground(labelBack);

	}

	protected override nothrow void characterInput(uint i) {
		//not implemented in Input yet
	}
}
