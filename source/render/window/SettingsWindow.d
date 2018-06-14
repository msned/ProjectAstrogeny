module render.window.SettingsWindow;

import render.screenComponents;
import render.responsiveControl;
import render.window.WindowObject;
import render.Color;
import std.conv;
import Settings;
import render.Fonts;

class SettingsWindow : WindowObject {
	
	this() {
		super("Settings", 640, 540);
	}

	protected override void loadRenderObjects() {
		ResponsiveRegion tabs = new HorizontalRegion(new AnchorPercentage(-1f, Side.left), new AnchorPercentage(1f, Side.top), new AnchorPercentage(1f, Side.right), new AnchorPixel(30f, true, Side.bottom), Side.bottom, 1);
		regions ~= tabs;
		
		//Regions for each Tab
		VerticalRegion controlGraphics = new VerticalRegion(new AnchorPercentage(.3f, Side.left), new AnchorRegion(tabs, Side.top), new AnchorPercentage(.9f, Side.right), new AnchorPercentage(-1f, Side.bottom), Side.right);
		VerticalRegion controlAudio = new VerticalRegion(controlGraphics);
		VerticalRegion controlControls = new VerticalRegion(controlGraphics);
		TabRegion tabControls = new TabRegion([controlGraphics, controlAudio, controlControls]);
		regions ~= tabControls;

		VerticalRegion valueGraphics = new VerticalRegion(new AnchorPercentage(0f, Side.left), new AnchorRegion(tabs, Side.top), new AnchorRegion(controlGraphics, Side.right), new AnchorPercentage(-1f, Side.right), Side.left);
		VerticalRegion valueAudio = new VerticalRegion(valueGraphics);
		VerticalRegion valueControls = new VerticalRegion(valueGraphics);
		TabRegion tabValues = new TabRegion([valueGraphics, valueAudio, valueControls]);
		regions ~= tabValues;

		VerticalRegion labelGraphics = new VerticalRegion(new AnchorPercentage(-1f, Side.left), new AnchorRegion(tabs, Side.top), new AnchorRegion(valueGraphics, Side.right), new AnchorPercentage(-1f, Side.bottom), Side.left);
		VerticalRegion labelAudio = new VerticalRegion(labelGraphics);
		VerticalRegion labelControls = new VerticalRegion(labelGraphics);
		TabRegion tabLabels = new TabRegion([labelGraphics, labelAudio, labelControls]);
		regions ~= tabLabels;

		//Graphics Elements
		{
			controlGraphics.addObject(new RenderSpacer(1f, 5f));
			labelGraphics.addObject(new RenderSpacer(1f, 10f));
			valueGraphics.addObject(new RenderSpacer(1f, 15f));
			RenderText vText = new RenderText(to!string(VSync), 100,  10, this);
			vText.setColor(Colors.Plum);
			valueGraphics.addObject(vText);
			controlGraphics.addObject(new RenderToggleSwitch(30f, Colors.Patina, (bool val) {
				VSync = val;
				vText.setText(to!string(val));
			}, this, VSync));
			labelGraphics.addObject(new RenderText("V-Sync", 100, 15, this));

			controlGraphics.addObject(new RenderSpacer(1f, 7f));
			labelGraphics.addObject(new RenderSpacer(1f, 10f));
			valueGraphics.addObject(new RenderSpacer(1f, 15f));
			RenderText gText = new RenderText(getString(GUIScale, 4), 100, 10, this);
			gText.setColor(Colors.Plum);
			valueGraphics.addObject(gText);
			RenderSlider gui = new RenderSlider(false, 20f, 5f, (float val) {
				GUIScale = val * 10;
				gText.setText(getString(GUIScale, 4));
			}, this, GUIScale / 10, true);
			gui.scrollDivider = 80;
			controlGraphics.addObject(gui);
			labelGraphics.addObject(new RenderText("GUI Scale*", 100, 15, this));

			controlGraphics.addObject(new RenderSpacer(1f, 10f));
			labelGraphics.addObject(new RenderSpacer(1f, 10f));
			valueGraphics.addObject(new RenderSpacer(1f, 25f));
			RenderDropdown fDr = new RenderDropdown(40f, 20f, Colors.Dark_Creek, GetFontType(), this);
			RenderScrollList rList = new RenderScrollList(40f, 35f, this);
			rList.setElements(
				[new RenderContentButton(40f, 20f, Colors.Oil_Blue, "Light", this, () {
					FontName = "rockwell_light";
					try {FontInit();} catch (Exception e){}
					fDr.setText("Light");
				}),
				new RenderContentButton(40f, 20f, Colors.Oil_Blue, "Regular", this, () {
					FontName = "rockwell";
					try {FontInit(); } catch (Exception e){}
					fDr.setText("Regular");
				}),
				new RenderContentButton(40f, 20f, Colors.Oil_Blue, "Bold", this, () {
					FontName = "rockwell_bold";
					try {FontInit();} catch (Exception e){}
					fDr.setText("Bold");
				})]);
			controlGraphics.addFixedObject(rList);
			fDr.setList(rList);
			controlGraphics.addObject(fDr);
			labelGraphics.addObject(new RenderText("Font Type", 100, 15, this));
		}

		//Audio Elements
		{
			controlAudio.addObject(new RenderSpacer(1f, 18f));
			labelAudio.addObject(new RenderSpacer(1f, 15f));
			valueAudio.addObject(new RenderSpacer(1f, 15f));
			RenderText mText = new RenderText(getString(MasterVolume, 4), 100, 10, this);
			mText.setColor(Colors.Plum);
			valueAudio.addObject(mText);
			RenderSlider master = new RenderSlider(false, 20f, 5f, (float val) {
				MasterVolume = val;
				mText.setText(getString(MasterVolume, 4));
			}, this, MasterVolume, true);
			master.scrollDivider = 100;
			controlAudio.addObject(master);
			labelAudio.addObject(new RenderText("Master Volume", 100, 15, this));
		}

		//assigning tab buttons to the tabs
		tabs.addObjects(cast(RenderObject[])tabLabels.setupTabButtons(tabValues.setupTabButtons(tabControls.setupTabButtons([new RenderContentButton(60, 30, Colors.Blue, "Graphics", this), new RenderContentButton(60, 30, Colors.Rose, "Audio", this), new RenderContentButton(50, 30, Colors.Alyx_Blue, "Controls", this)]))));

		RenderObject valueBack = new RenderObject("blank.png", this);
		valueBack.setColor(Colors.Light_Patina);
		valueBack.setDepth(.9f);
		//valueGraphics.setBackground(valueBack);
		RenderObject labelBack = new RenderObject("blank.png", this);
		labelBack.setColor(Colors.Purplez);
		labelBack.setDepth(.9f);
		//labelAudio.setBackground(labelBack);

	}

	private nothrow string getString(T)(T value, int maxLength = 0) {
		try {
			if (maxLength) {
				string s = to!string(value);
				if (s.length > maxLength)
					return s[0 .. maxLength];
				return s;
			}
			return to!string(value);
		} catch (Exception e) {}
		return "";
	}

	protected override nothrow void characterInput(uint i) {
		//not implemented in Input yet
	}
}
