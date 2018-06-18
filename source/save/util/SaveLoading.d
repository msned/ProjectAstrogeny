module save.util.SaveLoading;

import std.file;
import cerealed;
import save.GameSave;

immutable string defaultSaveLocation = "";
immutable string saveSuffix = ".Astr";

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

void StoreSave(T)(T sv, string name, string path = defaultSaveLocation) {
	static if (__traits(hasMember, T, "preSerialize"))
		sv.preSerialize();
	auto enc = Cerealiser();
	enc  ~= sv;
	write(path ~ name ~ saveSuffix, enc.bytes);
}