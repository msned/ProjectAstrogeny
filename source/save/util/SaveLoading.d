module save.util.SaveLoading;

import std.file;
import cerealed;
import save.GameSave;

immutable string defaultSaveLocation = "";
immutable string saveSuffix = ".Astr";

/*
Uses binary serialization through Cerealed to read all save data from disc and reconstruct each object
*/
T LoadSave(T)(string savePath) {
	if (exists(savePath)) {
		auto dec = Decerealiser(cast(byte[])read(savePath));
		T f = dec.value!T();
		static if (__traits(hasMember, T, "postSerialize"))
			f.postSerialize();
		return f;
	}
	return null;
}

/*
Uses binary serialization with Cerealed to write all the save data to disc
*/
void StoreSave(T)(T sv, string name, string path = defaultSaveLocation) {
	static if (__traits(hasMember, T, "preSerialize"))
		sv.preSerialize();
	auto enc = Cerealiser();
	enc  ~= sv;
	write(path ~ name ~ saveSuffix, enc.bytes);
}