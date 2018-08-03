module render.window.PropertyWindow;

import render.screenComponents;
import render.window.WindowObject;
import render.responsiveControl;
import std.traits;

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

	protected override void loadRenderObjects() {
		FillRegion names = new FillRegion(new AnchorPercentage(-1f, Side.left), new AnchorPercentage(1f, Side.top), new AnchorPercentage(0f, Side.right), new AnchorPercentage(-1f, Side.bottom));
		FillRegion values = new FillRegion(new AnchorPercentage(0f, Side.left), new AnchorPercentage(1f, Side.top), new AnchorPercentage(1f, Side.right), new AnchorPercentage(-1f, Side.bottom));
		regions ~= names;
		regions ~= values;
		listNames = new RenderScrollList(1f, 1f, this);
		listValues = new RenderScrollList(1f, 1f, this);
		names.setFill(listNames);
		values.setFill(listValues);
		nameList = [];
		valueList = [];
		import std.conv;
		import render.Color;

		static foreach(m; __traits(allMembers, T)) {
			static if (__traits(compiles, __traits(getMember, T, m))) {
				static if (hasUDA!(__traits(getMember, T, m), Display)) {
					static if (!isBasicType!(typeof(__traits(getMember, T, m))) /*&& getSymbolsByUDA!(__traits(getMember, T, m), Display).length > 0*/) {
						valueList ~= new RenderContentButton(80f, 20f, Colors.Blue3, typeof(__traits(getMember, T, m)).stringof, this, () {
							import render.window.WindowLoop;
							try {
							AddWindow(new PropertyWindow!(typeof(__traits(getMember, T, m)))(mixin("item." ~ m)));
							} catch (Exception) { assert(0); }
						});
					} else {
						valueList ~= new RenderTextBox(to!string(mixin("item." ~ m)), 80f, 20f, .25f, this);
					}
					nameList ~= new RenderTextBox(m.stringof, 80f, 20f, .25f, this);
				}
				else static if (hasUDA!(__traits(getMember, T, m), Edit)) {
					alias J = getUDAs!(__traits(getMember, T, m), Edit)[0].type;
					static if (is(J : int) || is(J : float) || is(J : string)) {
						valueList ~= new RenderTypeBoxValue!J(to!string(mixin("item." ~ m)), 80f, 20f, .25f, null, this);
						nameList ~= new RenderTextBox(m.stringof, 80f, 20f, .25f, this);
					}
				}
			}
		}
		
		listNames.setElements(nameList);
		listValues.setElements(valueList);
	}

}
