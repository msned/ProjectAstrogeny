module render.responsiveControl.TabRegion;

import render.responsiveControl;
import render.screenComponents;
import std.exception;
import Settings;
import render.window.WindowObject;

class TabRegion : ResponsiveRegion {

	ResponsiveRegion[] tabs;

	int currentTab = 0;
	int tabCount;
	
	/++
	Assumes all tabs have the same anchor points and priority, tab region is initialized with the first tab's settings
	+/
	this(ResponsiveRegion[] tabs) {
		static if (DEBUG)
			enforce(tabs.length > 1, "Must have more than two regions in a tabbed region");
		tabCount = tabs.length;
		super(tabs[0].getAnchor(Side.left), tabs[0].getAnchor(Side.top), tabs[0].getAnchor(Side.right), tabs[0].getAnchor(Side.bottom), tabs[0].priority);
		this.tabs = tabs;
	}

	public nothrow void setTab(int tabIndex) {
		if (tabIndex < tabCount)
			currentTab = tabIndex;
	}

	public RenderButton[] setupTabButtons(RenderButton[] buttons) {
		static if (DEBUG)
			enforce(buttons.length == tabs.length, "Number of buttons does not match number of tabs");
		foreach(int i, RenderButton b; buttons) {
			b.setClick(makeClick(i, b, buttons));
		}
		return buttons;
	}

	private void delegate() nothrow makeClick(int index, RenderButton ths, RenderButton[] others) {
		return (){
			foreach(RenderButton r; others) {
				if (auto c = cast(Selectable)r)
					c.setSelected(false);
			}
			if (auto c = cast(Selectable)ths)
				c.setSelected(true);
			setTab(index);
		};
	}

	public override nothrow RenderObject[] getRenderObjects() {
		return tabs[currentTab].getRenderObjects();
	}
	public override nothrow RenderObject[] getFixedRenderObjects() {
		return tabs[currentTab].getFixedRenderObjects();
	}

	public override nothrow void postInit(float width, float height) {
		foreach(ResponsiveRegion r; tabs)
			r.postInit(width, height);
	}

	public override void addObject(RenderObject o) {
		throw new Exception("Add objects on the regions for each tab, not on the tab region itself");
	}
	public override void removeObject(RenderObject o) {
		throw new Exception("Remove objects on the regions for each tab, not on the tab region itself");
	}
	public override void removeObject(int index) {
		throw new Exception("Remove objects on the regions for each tab, not on the tab region itself");
	}
	public override void addFixedObject(RenderObject o) {
		addObject(o);
	}
	public override void removeFixedObject(RenderObject o) {
		removeObject(o);
	}
	public override void removeFixedObject(int index) {
		removeObject(index);
	}

	public override void sortElements() {
		foreach(ResponsiveRegion r; tabs)
			r.sortElements();
	}

	public override nothrow void renderObjects() {
		tabs[currentTab].renderObjects();
	}

	public override nothrow void clearBounds() {
		foreach(ResponsiveRegion r; tabs)
			r.clearBounds();
	}

	public override nothrow void clearHidden() {
		foreach(ResponsiveRegion r; tabs)
			r.clearHidden();
	}

	public override nothrow bool updateElements(float width, float height) {
		foreach(ResponsiveRegion r; tabs)
			if (!r.updateElements(width, height))
				return false;
		return true;
	}
}
