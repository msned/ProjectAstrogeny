module Settings;

//
//constant values for testing/debug
//======================================//
immutable bool DEBUG = true;

immutable string VERSION = "0.0.2";

class GameSettings {
static:
	//Game Settings
	//======================================//
	//Graphics
	float GUIScale = 1.00f;
	bool VSync = true;
	string FontName = "rockwell";
	int FontSize = 128;
	//Audio
	float MasterVolume = 1f;
	//Controls

}
