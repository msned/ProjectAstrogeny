module save.util.SaveLoading;

import std.file;
import cerealed;
import save.GameSave;

const string defaultSaveLocation = "";
const string saveSuffix = ".Astr";

GameSaveFile LoadSave(string savePath) {
	if (exists(savePath)) {
		auto dec = Decerealiser(cast(byte[])read(savePath));
		return dec.value!GameSaveFile();
	}
	return null;
}

void StoreSave(GameSaveFile sv) {
	auto enc = Cerealiser();
	enc  ~= sv;
	write(defaultSaveLocation ~ sv.saveName ~ saveSuffix, enc.bytes);
}