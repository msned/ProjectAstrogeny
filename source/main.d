module MainEntry;
import std.stdio;
import derelict.glfw3.glfw3;
public import derelict.opengl;
mixin glFreeFuncs!(GLVersion.gl33);

GLFWwindow* window;
//GLContext context;
void main() {
	writeln("game start");
	DerelictGLFW3.load();
	DerelictGL3.load();
	if (!glfwInit())
		return;
	window = glfwCreateWindow(1280, 720, "Project Astrogeny", null, null);
	glfwMakeContextCurrent(window);
	DerelictGL3.reload();
	mainLoop();
	
}


void mainLoop() {
	while(!glfwWindowShouldClose(window)) {
		glfwSwapBuffers(window);
		glfwPollEvents();
	}
}
