module render.drawing.BasicChart;

import render.responsiveControl;
import render.screenComponents;
import render.window.WindowObject;
import derelict.opengl;
import std.uuid;
import render.Color;
import Settings;
import std.conv;

class RenderBasicChart : RenderObject, ResponsiveElement {

	private shared float[] dataX, dataY;

	const static char* vertexShaderSource = 
		"#version 330 core
		layout (location = 0) in vec3 vertex; // pos

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
		window = win;
		initRender(win);
	}

	private GLfloat[] line = [
		-10f, -10f, .5f,
		10f, 10f, .5f
	];

	private static bool[UUID] registeredOrtho;
	private WindowObject window;

	protected GLuint LineVBO, LineVAO;

	protected void initRender(WindowObject windowObj) {
		glGenVertexArrays(1, &VAO);
		glGenBuffers(1, &VBO);
		glBindVertexArray(VAO);
		glBindBuffer(GL_ARRAY_BUFFER, VBO);
		glBufferData(GL_ARRAY_BUFFER, GLfloat.sizeof * 2 * 3, null, GL_DYNAMIC_DRAW);
		glEnableVertexAttribArray(0);
		glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, GLfloat.sizeof * 3, cast(void*)0);

		glGenBuffers(1, &LineVBO);
		glGenVertexArrays(1, &LineVAO);
		glBindVertexArray(LineVAO);
		glBindBuffer(GL_ARRAY_BUFFER, LineVAO);
		glBufferData(GL_ARRAY_BUFFER, GLfloat.sizeof * 2 * 3, null, GL_DYNAMIC_DRAW);
		glEnableVertexAttribArray(0);
		glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, GLfloat.sizeof * 3, cast(void*)0);

		if (windowID !in chartPrograms)
			loadChartShader();
		glOrtho(windowObj.sizeX, windowObj.sizeY, windowID);
		if (windowID !in registeredOrtho) {
			orthoUpdates[windowID] ~= &glOrtho;
			registeredOrtho[windowID] = true;
		}

		for(int i = 0; i < labels.length; i++) {
			labels[i] = new RenderText("", 0, 0, .125f * GameSettings.GUIScale, window);
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

	public override void onDestroy() {
		glDeleteBuffers(1, &VBO);
		glDeleteVertexArrays(1, &VAO);
	}


	public nothrow void setData(shared float[] datX, shared float[] datY) {
		assert(datX.length == datY.length);
		dataX = datX;
		dataY = datY;
		float minValue = float.max, maxValue = -float.max;
		float minW = float.max, maxW = -float.max;
		foreach(float v; dataY) {
			if (v < minValue)
				minValue = v;
			if (v > maxValue)
				maxValue = v;
		}
		foreach(float v; dataX) {
			if (v < minW)
				minW = v;
			if (v > maxW)
				maxW = v;
		}
		labelIncrement(minValue, maxValue, minW, maxW);
		try {
			labels[0].setText(to!string(minY));
			labels[1].setText(to!string(minX));
			for(int i = 1; i <= NTICK; i++) {
				labels[i * 2].setText(to!string((minY + i * incrY).quantize(incrY)));
				labels[i * 2 + 1].setText(to!string((minX + i * incrX).quantize(incrX)));
			}
		} catch (Exception e) { assert(0); }

		updateVertices = true;
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

	float[] lines;
	float[6][22] marks;
	RenderText[22] labels;
	float[] lnD;

	float bound = 50f;

	public override nothrow void render() {
		if (!visible)
			return;

		if (updateVertices) {
			lines.length = 0;
			
			float startcornerX = xPos -width + bound * GameSettings.GUIScale, startcornerY = yPos -height + bound * GameSettings.GUIScale, 
				  endcornerY = yPos + height - bound * GameSettings.GUIScale, endcornerX = xPos + width - bound * GameSettings.GUIScale;
			marks[0] = [	//Vertical Axis
				startcornerX, startcornerY - 2f * GameSettings.GUIScale, .5f,
				startcornerX, endcornerY, .5f
			];
			marks[1] = [	//Horizontal Axis
				startcornerX - 2f * GameSettings.GUIScale, startcornerY, .5f,
				endcornerX, startcornerY, .5f
			];
			//Labels
			float hashX = (endcornerX - startcornerX) / NTICK, hashY = (endcornerY - startcornerY) / NTICK, hashLength = 10f * GameSettings.GUIScale;
			try {
				labels[0].setPosition(xPos - width + (bound - hashLength) / 2f, startcornerY);
				labels[1].setPosition(startcornerX, yPos - height + (bound - hashLength) / 2f);
			} catch (Exception e) { assert(0); }
			for(int i = 1; i <= NTICK; i++) {
				marks[i * 2] = [
					startcornerX - hashLength, startcornerY + i * hashY, .45f,
					startcornerX + hashLength, startcornerY + i * hashY, .45f
				];
				marks[i*2 + 1] = [
					startcornerX + i * hashX, startcornerY - hashLength, .45f,
					startcornerX + i * hashX, startcornerY + hashLength, .45f
				];
				try {
					labels[i * 2].setPosition(xPos - width + (bound - hashLength) / 2f, startcornerY + i * hashY);
					labels[i *2 + 1].setPosition(startcornerX + i * hashX, yPos - height + (bound - hashLength) / 2f);
				} catch (Exception e) { assert(0); }
			}
			//Lines
			float xRange = maxX - minX, yRange = maxY -  minY;

			//float xPos = startcornerX + (endcornerX - startcornerX) * (dataX[0] - minX) / xRange;
			//float yPos = startcornerY + (endcornerY - startcornerY) * (dataY[0] - minY) / yRange;
			for(int i = 0; i < dataX.length; i++) {
				float xPos = startcornerX + (endcornerX - startcornerX) * (dataX[i] - minX) / xRange;
				float yPos = startcornerY + (endcornerY - startcornerY) * (dataY[i] - minY) / yRange;
				lines ~= [
					xPos, yPos, .4f
				];
			}
			glBindBuffer(GL_ARRAY_BUFFER, LineVBO);
			glBufferData(GL_ARRAY_BUFFER, cast(int)float.sizeof * lines.length, lines.ptr, GL_DYNAMIC_DRAW);

			updateVertices = false;
		}

		glUseProgram(chartPrograms[windowID]);
		glUniform3f(glGetUniformLocation(chartPrograms[windowID], "lineColor"), colorR, colorG, colorB);
		
		glBindVertexArray(LineVAO);
		glBindBuffer(GL_ARRAY_BUFFER, LineVBO);
		glDrawArrays(GL_LINE_STRIP, 0, lines.length / 3);
		
		glBindVertexArray(VAO);
		glBindBuffer(GL_ARRAY_BUFFER, VBO);

		foreach(float[6] vs; marks) {
			glBufferSubData(GL_ARRAY_BUFFER, 0, cast(int)vs.sizeof, vs.ptr);
			glDrawArrays(GL_LINES, 0, 2);
		}
		foreach(RenderText t; labels) {
			t.render();
		}
		if (windowID in shaderPrograms)
			glUseProgram(shaderPrograms[windowID]);
	}


	/* Graph Calculation Methods 
	============================================
	*/

	import std.math;

	const static int NTICK = 10;
	float minY, maxY, incrY, minX, maxX, incrX;

	/*
	* Algorithm borrowed from Paul Heckbert
	* http://www.realtimerendering.com/resources/GraphicsGems/gems/Label.c
	* Converted by Jeremy Collier
	*/
	private nothrow void labelIncrement(float mY, float xY, float mX, float xX) {
		float range = nicenum(xY - mY, false);
		incrY = nicenum(range / (NTICK - 1), true);
		minY = floor(mY/incrY)*incrY;
		maxY = minY + incrY * NTICK;
		range = nicenum(xX - mX, false);
		incrX = nicenum(range / (NTICK - 1), true);
		minX = floor(mX/incrX)*incrX;
		maxX = minX + incrX * NTICK;
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
