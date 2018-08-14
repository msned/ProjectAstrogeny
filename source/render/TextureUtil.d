module render.TextureUtil;

import derelict.opengl.gl;
import derelict.opengl;
import imageformats.png;
import imageformats.util;
import std.uuid;

const static string texturePath = "textures/";

/++
Loads the texture by the given file name and returns the GLuint ID for it
+/
GLuint LoadTexture(string fileName, UUID windowID) {
	static GLuint[string][UUID] loadedTextures;

	if (windowID in loadedTextures) {
		GLuint* ptr = fileName in loadedTextures[windowID];
		if (ptr !is null) {
			return *ptr;
		}
	}
	GLuint texture;
	glGenTextures(1, &texture);
	glBindTexture(GL_TEXTURE_2D, texture);
	IFImage ld = read_image(texturePath ~ fileName);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, ld.w, ld.h, 0, GL_RGBA, GL_UNSIGNED_BYTE, cast(ubyte*)ld.pixels);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glGenerateMipmap(GL_TEXTURE_2D);

	loadedTextures[windowID][fileName] = texture;
	return texture;
}
