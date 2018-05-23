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
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_DEPTH_TEST);
	glfwSwapInterval(1);
	return true;
}

void OpenglPreRender() {
	glClear(GL_COLOR_BUFFER_BIT);
	glClear(GL_DEPTH_BUFFER_BIT);
	glClearColor(177 / 255f, 57 / 255f, 208 / 255f, 1f);
}
