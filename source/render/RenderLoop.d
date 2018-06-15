module render.RenderLoop;

import derelict.opengl;
import render.TextureUtil;
import derelict.glfw3.glfw3;
import std.stdio;
import std.conv;
import Settings;

/++
	Initializes the OpenGL settings, returns success
+/
public nothrow bool RenderInit() {
	try {
		auto loaded = DerelictGL3.reload();
		//writeln(loaded);
	} catch (Exception e) {
		try {
		writeln("Error loading %s", DerelictGL3.loadedVersion);
		} catch (Exception e) {}
	}
	glEnable(GL_TEXTURE_2D);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_DEPTH_TEST);
	glEnable(GL_DEBUG_OUTPUT);
	glDebugMessageCallback(&MessageCallback, cast(void*)0);
	glEnable(GL_SCISSOR_TEST);
	if (GameSettings.VSync)
		glfwSwapInterval(1);
	else
		glfwSwapInterval(0);
	return true;
}

nothrow void OpenglPreRender() {
	glClearColor(29 / 255f, 70 / 255f, 94 / 255f, 1f);
	glClear(GL_COLOR_BUFFER_BIT);
	glClear(GL_DEPTH_BUFFER_BIT);
}
extern (Windows)
nothrow void MessageCallback(GLenum source, GLenum type, GLuint id, GLenum severity, GLsizei length, const GLchar* message, void* userparam) {
	if (severity > 33387)
		try {
			writeln("OpenGl Error: ", to!string(message));
			throw new Exception(to!string(message));
		} catch (Exception e) {}
}
