module render.window.DisplayUtils;

import std.conv;

nothrow string getString(T)(T value, int maxLength = 0) {
	try {
		if (maxLength) {
			string s = to!string(value);
			if (s.length > maxLength)
				return s[0 .. maxLength];
			return s;
		}
		return to!string(value);
	} catch (Exception e) {
		return "";
	}
	
}
