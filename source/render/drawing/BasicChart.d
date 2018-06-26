module render.drawing.BasicChart;

import render.responsiveControl;
import render.screenComponents;
import render.window.WindowObject;
import derelict.opengl;
import std.uuid;
import render.Color;
import Settings;

class RenderBasicChart : RenderObject, ResponsiveElement {

	private float[] data;

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
	
	this(float width, float height, WindowObject win) {
		this.width = width;
		this.height = height;
		windowID = win.windowID;
		initRender(win);
	}

	private GLfloat[] line = [
		-10f, -10f, .5f,
		10f, 10f, .5f
	];

	private static bool[UUID] registeredOrtho;

	protected void initRender(WindowObject windowObj) {
		glGenVertexArrays(1, &VAO);
		glGenBuffers(1, &VBO);
		glBindVertexArray(VAO);
		glBindBuffer(GL_ARRAY_BUFFER, VBO);
		glBufferData(GL_ARRAY_BUFFER, GLfloat.sizeof * 2 * 3, null, GL_DYNAMIC_DRAW);
		glEnableVertexAttribArray(0);
		glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, GLfloat.sizeof * 3, cast(void*)0);

		if (!(windowID in chartPrograms))
			loadChartShader();
		glUseProgram(chartPrograms[windowID]);
		glOrtho(windowObj.sizeX, windowObj.sizeY, windowID);
		glUniformMatrix4fv(glGetUniformLocation(chartPrograms[windowID], "proj"), 1, GL_FALSE, &projMatrices[windowID][0]);
		if (windowID !in registeredOrtho) {
			orthoUpdates[windowID] ~= &glOrtho;
			registeredOrtho[windowID] = true;
		}

	}
	private static GLuint[UUID] chartPrograms;

	private void loadChartShader() {

		int vertexShader = glCreateShader(GL_VERTEX_SHADER);
		glShaderSource(vertexShader, 1, &vertexShaderSource, null);
		glCompileShader(vertexShader);
		int success;
		glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
		if (!success) 
			throw new Exception("Vertex Shader Error");

		int fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
		glShaderSource(fragmentShader, 1, &fragmentShaderSource, null);
		glCompileShader(fragmentShader);
		glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);
		if (!success)
			throw new Exception("Fragment Shader Error");
		chartPrograms[windowID] = glCreateProgram();
		glAttachShader(chartPrograms[windowID], vertexShader);
		glAttachShader(chartPrograms[windowID], fragmentShader);
		glLinkProgram(chartPrograms[windowID]);
		glGetProgramiv(chartPrograms[windowID], GL_LINK_STATUS, &success);
		if (!success)
			throw new Exception("Linking Shader Error");

		glDeleteShader(vertexShader);
		glDeleteShader(fragmentShader);
	}

	public override nothrow void glOrtho(GLdouble width, GLdouble height, UUID winID) {
		initProj(winID);
		projMatrices[winID][0] = 2.0f/(width);
		projMatrices[winID][5] = 2.0f/(height);
		glUseProgram(chartPrograms[windowID]);
		glUniformMatrix4fv(glGetUniformLocation(chartPrograms[winID], "proj"), 1, GL_FALSE, &projMatrices[winID][0]);
		if (winID in shaderPrograms)
			glUseProgram(shaderPrograms[winID]);
	}

	public nothrow void setData(float[] dat) {
		data = dat;
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

	public override nothrow void setPosition(float x, float y) {
		xPos = x;
		yPos = y;
		updateVertices = true;
	}

	protected float colorR = Colors.Golden_Dragons.red, colorG = Colors.Golden_Dragons.green, colorB = Colors.Golden_Dragons.blue;

	float[6][] lines;
	float[6][] marks;

	float bound = 20f;

	public override nothrow void render() {
		if (!visible)
			return;

		if (updateVertices) {
			marks = [];
			float minValue = cast(float)long.max, maxValue = cast(float)long.min;
			foreach(float v; data) {
				if (v < minValue)
					minValue = v;
				else if (v > maxValue)
					maxValue = v;
			}
			float startcornerX = -width/2f + bound * GameSettings.GUIScale, startcornerY = -height/2f + bound * GameSettings.GUIScale, endcornerY = height/2f - bound * GameSettings.GUIScale;
			float incr = labelIncrement(minValue, maxValue);
			for(int i = 0; i < NTICK; i++) {
				
			}
			marks ~= [
				startcornerX, startcornerY, .5f,
				startcornerX, endcornerY, .5f
			];
		}

		glUseProgram(chartPrograms[windowID]);
		glUniform3f(glGetUniformLocation(chartPrograms[windowID], "lineColor"), colorR, colorG, colorB);	//TODO: set flag for updating uniforms

		glBindVertexArray(VAO);
		glBindBuffer(GL_ARRAY_BUFFER, VBO);

		lines = [[
			-20f, 40f, .5f,
			20f, -33f, .5f
		], [
			40f, 0f, .5f,
			0f, 10f, .5f
		]];

		foreach(float[6] vs; lines) {
			glBufferSubData(GL_ARRAY_BUFFER, 0, cast(int)vs.sizeof, vs.ptr);
			glDrawArrays(GL_LINES, 0, 2);
		}
		foreach(float[6] vs; marks) {
			glBufferSubData(GL_ARRAY_BUFFER, 0, cast(int)vs.sizeof, vs.ptr);
			glDrawArrays(GL_LINES, 0, 2);
		}
		if (windowID in shaderPrograms)
			glUseProgram(shaderPrograms[windowID]);
	}

	/* Graph Calculation Methods 
	============================================
	*/

	import std.math;

	int NTICK = 10;
	float MINY, MAXY;

	/*
	* Algorithm borrowed from Paul Heckbert
	* http://www.realtimerendering.com/resources/GraphicsGems/gems/Label.c
	* Converted by Jeremy Collier
	*/
	private nothrow float labelIncrement(float min, float max) {
		float range = nicenum(max - min, false);
		float d = nicenum(range / (NTICK - 1), true);
		MINY = floor(min/d)*d;
		MAXY = ceil(max/d)*d;
		return d;
	}

	private nothrow float nicenum(float x, bool round) {
		int expv;
		float f, nf;

		expv = cast(int)floor(log10(x));
		f = x/expt(10, expv);
		if (round) {
			if (f < 1.5)
				nf = 1;
			else if (f < 3)
				nf = 2;
			else if (f < 7)
				nf = 5;
			else
				nf = 10;
		} else {
			if (f <= 1)
				nf = 1;
			else if (f <= 2)
				nf = 2;
			else if (f <= 5)
				nf = 5;
			else
				nf = 10;
		}
		return nf*expt(10, expv);
	}

	private nothrow float expt(double a, int n)	{
		double x;
		x = 1;
		if (n>0) for (; n>0; n--) x *= a;
		else for (; n<0; n++) x /= a;
		return x;
	}
}
