module render.Color;

enum Colors : Color{Patina = Color(49 / 255f, 146 / 255f, 113 / 255f), White = Color(1f, 1f, 1f), Golden_Dragons = Color(206 / 255f, 196 / 255f, 21 / 255f),
					Flower = Color(210 / 255f, 118 / 255f, 94 / 255f), Rose = Color(149 / 255f, 5 / 255f, 50 / 255f), Cerulean = Color(29 / 255f, 70 / 255f, 94 / 255f),
					Blue = Color(1 / 255f, 78 / 255f, 124 / 255f), Clues = Color(113 / 255f, 125 / 255f, 250 / 255f), Purplez = Color(196 / 255f, 116 / 255f, 237 / 255f),
					Citron = Color(210 / 255f, 251 / 255f, 120 / 255f), Black = Color(0f, 0f, 0f)};

struct Color {
	float red;
	float green;
	float blue;
}
