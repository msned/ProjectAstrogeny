module Settings;

//
//constant values for testing/debug
//======================================//
immutable bool DEBUG = true;

immutable string VERSION = "0.0.2";

class GameSettings {
shared
static:
	//Game Settings
	//======================================//
	//Graphics
	float GUIScale = GameSettingsDefault.GUIScale;
	bool VSync = GameSettingsDefault.VSync;
	string FontName = GameSettingsDefault.FontName;
	int FontSize = GameSettingsDefault.FontSize;
	//Audio
	float MasterVolume = GameSettingsDefault.MasterVolume;
	//Controls

}
class GameSettingsDefault {
shared
static:
	immutable float GUIScale = 1f;
	immutable bool VSync = true;
	immutable string FontName = "rockwell";
	immutable int FontSize = 128;
	immutable float MasterVolume = 1f;
}
