module render.window.PropertyWindow;

import render.screenComponents;
import render.window.WindowObject;
import render.responsiveControl;
import render.window.DisplayUtils;
import std.traits;
import render.Color;

enum Display;
struct Edit (T) {
	alias type = T;
}

class PropertyWindow (T) : WindowObject {

	T item;
	
	this(T obj) {
		item = obj;
		super(T.stringof ~ " Properties");
	}

	RenderScrollList listNames, listValues;
	RenderObject[] nameList, valueList;

	private immutable float textSize = .25f;
	private immutable int maxDigits = 7;

	int labelWidth = 0;
	int rowNum = 0;

	protected override void loadRenderObjects() {
		FillRegion names = new FillRegion(new AnchorPercentage(-.95f, Side.left), new AnchorPercentage(1f, Side.top), new AnchorPercentage(0f, Side.right), new AnchorPercentage(-1f, Side.bottom));
		FillRegion values = new FillRegion(new AnchorPercentage(0f, Side.left), new AnchorPercentage(1f, Side.top), new AnchorPercentage(1f, Side.right), new AnchorPercentage(-1f, Side.bottom));
		regions ~= names;
		regions ~= values;
		listNames = new RenderScrollList(1f, 1f, this);
		listValues = new RenderScrollList(1f, 1f, this);
		listNames.linkedScroll ~= listValues;
		listValues.linkedScroll ~= listNames;
		names.setFill(listNames);
		values.setFill(listValues);
		nameList = [];
		valueList = [];

		static foreach(m; __traits(allMembers, T)) {
			static if (__traits(compiles, __traits(getMember, T, m))) {
				static if (hasUDA!(__traits(getMember, T, m), Display) || hasUDA!(__traits(getMember, T, m), Edit)) {
					static if (!isBasicType!(typeof(__traits(getMember, T, m))) && is(typeof(__traits(allMembers, typeof(__traits(getMember, T, m)))))) {
						valueList ~= new RenderContentButton(80f, 20f, Colors.Blue3, typeof(__traits(getMember, T, m)).stringof, this, () {
							import render.window.WindowLoop;
							try {
								import derelict.glfw3;
								auto w = new PropertyWindow!(typeof(__traits(getMember, T, m)))(mixin("item." ~ m));
								int x, y;
								glfwGetWindowPos(window, &x, &y);
								glfwSetWindowPos(w.getGLFW(), x, y);
								AddWindow(w);
							} catch (Exception) { assert(0); }
						});
					} else {
						static if (hasUDA!(__traits(getMember, T, m), Display))
							valueList ~= new RenderTextBox(getString(mixin("item." ~ m), maxDigits), 80f, 20f, textSize, this);
						else static if(hasUDA!(__traits(getMember, T, m), Edit)) {
							alias J = getUDAs!(__traits(getMember, T, m), Edit)[0].type;
							static if (is(J : int) || is(J : float) || is(J : string))
								valueList ~= new RenderTypeBoxValue!J((!is(J : string)) ? getString(mixin("item." ~ m), maxDigits) : mixin("item." ~ m), 80f, 20f, textSize, genValueDel!J(&mixin("item." ~ m)), this);
						}
					}
					nameList ~= new RenderTextBox(m, 80f, 20f, textSize, this, 1);
					if (m.stringof.length > labelWidth)
						labelWidth = m.stringof.length;
					rowNum++;
				}
			}
		}
		listNames.setElements(nameList);
		listValues.setElements(valueList);
		import Settings;
		updateWindowSize(cast(int)(labelWidth * 150 * GameSettings.GUIScale * textSize), (rowNum * 44 < sizeY) ? (rowNum * 44) : sizeY);
	}

	private nothrow void delegate(T) nothrow genValueDel(T)(T* item) {
		return (T val) nothrow {
			*item = val;
		};
	}

}
