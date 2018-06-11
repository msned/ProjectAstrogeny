module render.Color;

enum Colors : Color{Patina = Color(49 / 255f, 146 / 255f, 113 / 255f), White = Color(1f, 1f, 1f), Golden_Dragons = Color(206 / 255f, 196 / 255f, 21 / 255f),
					Flower = Color(210 / 255f, 118 / 255f, 94 / 255f), Rose = Color(149 / 255f, 5 / 255f, 50 / 255f), Cerulean = Color(29 / 255f, 70 / 255f, 94 / 255f),
					Blue = Color(1 / 255f, 78 / 255f, 124 / 255f), Clues = Color(113 / 255f, 125 / 255f, 250 / 255f), Purplez = Color(196 / 255f, 116 / 255f, 237 / 255f),
					Citron = Color(210 / 255f, 251 / 255f, 120 / 255f), Black = Color(0f, 0f, 0f), Light_Grey = Color(190 / 255f, 188 / 255f, 189 / 255f),
					Light_Patina = Color(89 / 255f, 166 / 255f, 148 / 255f), Alyx_Blue = Color(64 / 255f, 88 / 255f, 112 / 255f), Plum = Color(95 / 255f, 86 / 255f, 129 / 255f),
					Rose_Buds = Color(168 / 255f, 72 / 255f, 99 / 255f), Dark_Creek = Color(20 / 255f, 32 / 255f, 58 / 255f), Oil_Blue = Color(49 / 255f, 60 / 255f, 90 / 255f),
					Creation = Color(101 / 255f, 132 / 255f, 134 / 255f), Wedding_Blue = Color(87 / 255f, 184 / 255f, 226 / 255f), Mystic = Color(8 / 255f, 37 / 255f, 45 / 255f)};

struct Color {
	float red;
	float green;
	float blue;
}
