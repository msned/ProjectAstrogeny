module render.drawing.MapBase;

import render.screenComponents;
import render.window.WindowObject;
import render.responsiveControl;
import std.uuid;

class RenderMapBase : RenderObject, ResponsiveElement {

	const static char* vertexShaderSource = 
		"#version 330 core
		layout (location = 0) in vec3 vertex; // <vec2 pos, vec2 tex>

		uniform mat4 proj;

		void main()
		{
		gl_Position = proj * vec4(vertex, 1.0);
		}";
	const static char* fragmentShaderSource = 
		"#version 330 core
		out vec4 color;

		uniform vec3 lineColor;

		void main()
		{
		color = vec4(lineColor, 1.0);
		} ";


	private WindowObject window;
	private static bool[UUID] registeredOrtho;

	this(float width, float height, WindowObject win) {
		this.width = width;
		this.height = height;
		windowID = win.windowID;
		window = win;
	}

	public nothrow float getMinWidth() {
		return 0;
	}
	public nothrow float getDefaultWidth() {
		return width;
	}
	public nothrow float getMinHeight() {
		return 0;
	}
	public nothrow float getDefaultHeight() {
		return height;
	}
	public nothrow bool isStretchy() {
		return true;
	}

	public nothrow override void render() {
		
	}
	
}
