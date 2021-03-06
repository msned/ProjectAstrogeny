module save.util.JSONLoading;

import std.json;
import std.file;
import std.traits;
import std.stdio : writeln;
import Settings;

const string settingsName = "Settings.cfg";


/*
Uses compile-time reflection to identify all public variables in the settings file and set them when reading from the save
*/
void LoadSettingsFile() {
	if (exists(settingsName)) {
		string s = cast(string)read(settingsName);
		JSONValue set = parseJSON(s);
		foreach(key, val; set.object) {
			static foreach(m; __traits(allMembers, GameSettings)) {
				static if (hasStaticMember!(GameSettings, m) && !isCallable!(mixin("GameSettings." ~ m)))
					if (key == m.stringof[1 .. $ - 1]) {
						alias j = typeof(__traits(getMember, GameSettings, m));
						parseJSONValue!j(val, __traits(getMember, GameSettings, m));
					}
			}
		}
	} else {
		SaveSettingsFile();
	}
}

/*
Uses compile-time reflection to identify all the public variables to be saved to disc and saves each one in order to the JSON file
*/
void SaveSettingsFile() {
	JSONValue set = ["Version" : VERSION];
	static foreach(i, m; __traits(allMembers, GameSettings)) {
		static if (hasStaticMember!(GameSettings, m) && !isCallable!(mixin("GameSettings." ~ m))) {
			set.object[m.stringof[1 .. $ - 1]] = JSONValue(__traits(getMember, GameSettings, m));
		}
	}
	write(settingsName, set.toPrettyString());
}

/*
Casts the JSONValue as returned from disc to the correct value for the variable
*/
private void parseJSONValue(T)(JSONValue json, ref T value) {
	switch(json.type) with (JSON_TYPE) {
		case TRUE:
			static if (is(T : bool))
				value = cast(T)true;
			break;
		case FALSE:
			static if (is(T : bool))
				value = cast(T)false;
			break;
		case STRING:
			static if (is (T : string))
				value = cast(T)json.str;
			break;
		case INTEGER:
			static if (is(T : int))
				value = cast(T)json.integer;
			break;
		case UINTEGER:
			static if (is(T : uint))
				value = cast(T)json.uinteger;
			break;
		case FLOAT:
			static if (is(T : float))
				value = cast(T)json.floating;
			break;
		default:
			break;
	}
}
