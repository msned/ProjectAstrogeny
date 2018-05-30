module render.window.TestWindow;

import render.screenComponents;
import derelict.glfw3;
import render.window.WindowObject;
import std.stdio;

class TestWindow : WindowObject {

	this() {
		super("Test Window", 540, 540);
	}
	this(string name) {
		super(name, 540, 540);
	}

	protected override void loadRenderObjects() {
		glfwMakeContextCurrent(window);
		objects ~= new RenderObject(100, 200, 0, "file_edit.png", this);
		RenderObject xd = new RenderObject("random3.png", this);
		xd.setDepth(0.3f);
		objects ~= xd;
		objects ~= new RenderText("file_edit.png", 0, 0, .5f, this);
		objects ~= new RenderText("heyo", -100, 100, .5f, this);

		sortRenderObjects();
	}

	public override nothrow void characterInput(uint i) {

	}

}
