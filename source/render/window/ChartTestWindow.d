module render.window.ChartTestWindow;

import render.screenComponents;
import render.responsiveControl;
import render.window.WindowObject;
import render.window.ChartWindow;
import render.Color;
import derelict.glfw3;
import render.window.WindowLoop;

class ChartTestWindow : WindowObject {
	
	this() {
		super("Chart Data", 240, 480);
	}

	protected override void loadRenderObjects() {
		ResponsiveRegion top = new VerticalRegion(new AnchorPercentage(-1f, Side.left), new AnchorPercentage(1f, Side.top), new AnchorPercentage(1f, Side.right), new AnchorPixel(80, true, Side.bottom));
		regions ~= top;
		ResponsiveRegion bottom = new VerticalRegion(new AnchorPercentage(-1f, Side.left), new AnchorPixel(60, true, Side.top), new AnchorPercentage(1f, Side.right), new AnchorPercentage(-1f, Side.bottom));
		regions ~= bottom;
		FillRegion scrollL = new FillRegion(new AnchorPercentage(-1f, Side.left), new AnchorRegion(top, Side.top), new AnchorPercentage(-0.05f, Side.right), new AnchorRegion(bottom, Side.bottom));
		FillRegion scrollR = new FillRegion(new AnchorPercentage(0.05f, Side.left), new AnchorRegion(top, Side.top), new AnchorPercentage(1f, Side.right), new AnchorRegion(bottom, Side.bottom));
		regions ~= scrollL;
		regions ~= scrollR;
		listL = new RenderScrollList(100f, 100f, this);
		listR = new RenderScrollList(100f, 100f, this);
		listL.linkedScroll ~= listR;
		listR.linkedScroll ~= listL;
		scrollL.setFill(listL);
		scrollR.setFill(listR);
		listL.setColor(Colors.Flower);


		top.addObject(new RenderTextBox(" Number of points", 120, 20f, .2f, this, 1));
		RenderTypeBoxValue!int v = new RenderTypeBoxValue!int(" ", 80, 20, .2f, &updateScrollList, this, 1);
		v.setBackground(Colors.Blue4);
		top.addObject(v);

		bottom.addObject(new RenderContentButton(80f, 20f, Colors.Blue3, "Chart!", this, () {
			try {
				ChartWindow w = new ChartWindow();
				w.setData(cast(shared)Xvalues, cast(shared)Yvalues);
				AddWindow(w);
			} catch (Exception e) { assert(0); }
		}));
		bottom.addObject(new RenderContentButton(80f, 20f, Colors.Blue4, "(Sine)", this, () {
			import std.math;
			try {
				float[200] xValues, yValues;
				for(int i = 0; i < 200; i++) {
					xValues[i] = i * .05;
					yValues[i] = sin(xValues[i]);
				}
				ChartWindow w = new ChartWindow();
				w.setData(cast(shared)xValues.dup, cast(shared)yValues.dup);
				AddWindow(w);
			} catch (Exception e) { assert(0); }
		}));
		
	}
	RenderScrollList listL, listR;

	private float[] Xvalues;
	private float[] Yvalues;


	private nothrow void updateScrollList(int number) {
		RenderObject[] elemL;
		RenderObject[] elemR;
		Xvalues.length = number;
		Yvalues.length = number;

		void delegate(float) nothrow makeDel(int index, bool x) {
			if (x)
				return (float i) {
					Xvalues[index] = i;
				};
			else
				return (float i) {
					Yvalues[index] = i;
				};
		}

		try {
			GLFWwindow* current = glfwGetCurrentContext();
			glfwMakeContextCurrent(getGLFW());
			for(int i = 0; i < number; i++) {
				RenderTypeBoxValue!float nL = new RenderTypeBoxValue!float(" ", 90, 20, .2f, makeDel(i, true), this, 1);
				nL.setBackground(Colors.Blue4);
				RenderTypeBoxValue!float nR = new RenderTypeBoxValue!float(" ", 90, 20, .2f, makeDel(i, false), this, 1);
				nR.setBackground(Colors.Blue4);
				elemL ~= nL;
				elemR ~= nR;
			}
			glfwMakeContextCurrent(current);
		} catch (Exception e) { assert(0); }
		listL.setElements(elemL);
		listR.setElements(elemR);
	}
}
