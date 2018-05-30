module render.window.DebugWindow;

import render.screenComponents;
import render.window.WindowObject;

class DebugWindow : WindowObject {

	this() {
		super("Debug Window", 540, 960);
	}

	protected override void loadRenderObjects() {
		objects ~= new RenderObject(-100, -300, .4f, "random2.png", this);
		objects ~= new RenderObject(-80, -300, .8f, "random3.png", this);
		objects ~= new RenderObject(-110, -300, 0.9f, "file_edit.png", this);
		objects ~= new RenderText("Echo world", 100, 100, .5f, this);
		objects ~= new RenderText("Heck", 0, 0, 1f, this);
		objects ~= new RenderButton(0, 200, .2f, "file_search.png", this);
		objects ~= new RenderText("click",-20, 200, .3f, this);
		sortRenderObjects();
	}



	public override nothrow void characterInput(uint i) {
		
	}
	
}
