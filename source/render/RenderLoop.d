module render.RenderLoop;

import derelict.opengl;
import render.TextureUtil;
import derelict.glfw3.glfw3;
import std.stdio;
import std.conv;
import Settings;
import render.Color;

/++
Initializes the OpenGL settings for each window
+/
public nothrow void RenderInit() {
	try {
		DerelictGL3.reload();
	} catch (Exception e) {
		try {
		writeln("Error loading %s", DerelictGL3.loadedVersion);
		} catch (Exception e) {}
	}
	glEnable(GL_TEXTURE_2D);
	glEnable(GL_BLEND);
	glEnable(GL_LINE_SMOOTH);
	glEnable(GL_MULTISAMPLE);
	glLineWidth(4f * GameSettings.GUIScale);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_DEPTH_TEST);
	glEnable(GL_DEBUG_OUTPUT);
	glDebugMessageCallback(&MessageCallback, cast(void*)0);
	glEnable(GL_SCISSOR_TEST);
	if (GameSettings.VSync)
		glfwSwapInterval(1);
	else
		glfwSwapInterval(0);
}

nothrow void OpenglPreRender() {
	glClearColor(Colors.Blue5.red, Colors.Blue5.green, Colors.Blue5.blue, 1f);
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
