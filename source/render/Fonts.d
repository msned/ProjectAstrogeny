module render.Fonts;

import derelict.freetype;
import derelict.opengl;
import std.stdio;
import Settings;
import std.uuid;

__gshared FT_Library ft;
__gshared FT_Face face;


void FontInit(UUID winID) {
	if (ft is null)
		if (FT_Init_FreeType(&ft))
			throw new Exception("FreeType failed to load");
	if (face is null)
		if (FT_New_Face(ft, cast(const(char)*)("fonts/" ~ GameSettings.FontName ~ ".ttf"), 0, &face)) {
			throw new Exception("Font failed to load");
		}

	FT_Set_Pixel_Sizes(face, 0, GameSettings.FontSize);
	for(GLubyte c = 0; c < 128; c++) {
		if (FT_Load_Char(face, c, FT_LOAD_RENDER)) {
			writeln("failed to load character: %c", c);
			continue;
		}

		glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
		GLuint texture;
		glGenTextures(1, &texture);
		glBindTexture(GL_TEXTURE_2D, texture);
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RED, face.glyph.bitmap.width, face.glyph.bitmap.rows, 0, GL_RED, GL_UNSIGNED_BYTE, face.glyph.bitmap.buffer);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glGenerateMipmap(GL_TEXTURE_2D);
		Character ch = {texture, 
			face.glyph.bitmap.width, face.glyph.bitmap.rows,
			face.glyph.bitmap_left, face.glyph.bitmap_top,
			face.glyph.advance.x
		};
		Characters[winID][c] = ch;
	}
}

void NewFont(UUID winID) {
	face = null;
	FontInit(winID);
}

string GetFontType() {
	switch(GameSettings.FontName) {
		case "rockwell":
			return "Regular";
		case "rockwell_light":
			return "Light";
		case "rockwell_bold":
			return "Bold";
		default:
			return GameSettings.FontName;
	}
}

struct Character {
	GLuint TextureID;
	int xSize, ySize;
	int xBearing, yBearing;
	GLuint Advance;
};

Character[GLchar][UUID] Characters;
