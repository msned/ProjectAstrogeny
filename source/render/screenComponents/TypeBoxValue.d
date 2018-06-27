module render.screenComponents.TypeBoxValue;

import render.screenComponents;
import render.window.WindowObject;
import std.conv;

enum TypeLimit { Float, Int, Text };

class RenderTypeBoxValue(T) : RenderTypeBox {

	TypeLimit lim;

	void delegate(T) nothrow callback;

	this(string initialText, float width, float height, float scale, void delegate(T) nothrow valueCallback, WindowObject win, int protectedChars = 0, bool stretchy = true) {
		super(initialText, width, height, scale, win, protectedChars, 1, stretchy);
		if (is(T : int))
			lim = TypeLimit.Int;
		else if (is(T : float))
			lim = TypeLimit.Float;
		else if (is(T : string))
			lim = TypeLimit.Text;
		else
			throw new Exception("Invalid/Unsupported type for RenderTypeBoxValue");
		callback = valueCallback;
	}

	public override nothrow void updateValue() {
		super.updateValue();
		try {
			string val = displayText[protectedChars .. $];
			if (val.length > 0)
				callback(to!T(val));
		} catch (Exception e) {
			writelnNothrow("Cast error!");
			callback(T.init);
		}
	}

	public override nothrow void charInput(uint c) {
		if (!focused)
			return;
		switch(lim) {
			case TypeLimit.Int:
				if (c >= 0x30 && c <= 0x39 || c == 0x2D)
					super.charInput(c);
				break;
			case TypeLimit.Float:
				if (c >= 0x30 && c <= 0x39 || c == 0x2E || c == 0x2D)
					super.charInput(c);
				break;
			default:
			case TypeLimit.Text:
				super.charInput(c);
				break;
		}
	}
	
}
