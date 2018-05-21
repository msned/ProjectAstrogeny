module Render.RenderLoop;
public import derelict.opengl;

mixin glFreeFuncs!(GLVersion.gl33);

/++
	Initializes the OpenGL settings, returns success
+/
public bool RenderInit() {
	DerelictGL3.load();
	return true;
}

void OpenglRender() {
	glClear(GL_COLOR_BUFFER_BIT);
	glClearColor(1f, 1f, 1f, 1f);
}
