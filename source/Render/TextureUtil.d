module Render.TextureUtil;

import derelict.opengl.gl;
import derelict.opengl;
import imageformats.png;
import imageformats.util;

const static string texturePath = "textures/";

GLuint LoadTexture(string fileName) {
	static GLuint[string] loadedTextures;

	GLuint* ptr = fileName in loadedTextures;
	if (ptr !is null) {
		return *ptr;
	} else {
		GLuint texture;
		glGenTextures(1, &texture);
		glBindTexture(GL_TEXTURE_2D, texture);
		IFImage ld = read_image(texturePath ~ fileName);
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, ld.w, ld.h, 0, GL_RGBA, GL_UNSIGNED_BYTE, cast(ubyte*)ld.pixels);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
		glGenerateMipmap(GL_TEXTURE_2D);

		loadedTextures[fileName] = texture;
		return texture;
	}
}
