module Render.RenderLoop;
import derelict.opengl;
import Render.TextureUtil;
import derelict.glfw3.glfw3;
import std.stdio;

/++
	Initializes the OpenGL settings, returns success
+/
public bool RenderInit() {
	try {
		auto loaded = DerelictGL3.reload();
		//writeln(loaded);
	} catch (Exception e) {
		writeln("Error loading %s", DerelictGL3.loadedVersion);
	}
	glEnable(GL_TEXTURE_2D);
	//glEnable(GL_DEPTH_TEST);
	glfwSwapInterval(1);
	return true;
}

void OpenglPreRender() {
	glClear(GL_COLOR_BUFFER_BIT);
	glClearColor(1f, 1f, 1f, 1f);
}
