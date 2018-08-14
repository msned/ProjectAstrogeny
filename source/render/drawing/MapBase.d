module render.drawing.MapBase;

import render.screenComponents;
import render.window.WindowObject;
import render.responsiveControl;
import world.generation.Planet_gen;
import world.generation.Star_gen;
import world.SolarSystem;
import derelict.opengl;
import render.Color;
import std.uuid;

class RenderMapBase : RenderObject, ResponsiveElement {

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


	private WindowObject window;
	private static bool[UUID] registeredOrtho;

	this(float width, float height, WindowObject win) {
		this.width = width;
		this.height = height;
		windowID = win.windowID;
		window = win;
		initRender(win);
	}

	protected void initRender(WindowObject windowObj) {
		glGenVertexArrays(1, &VAO);
		glGenBuffers(1, &VBO);
		glBindVertexArray(VAO);
		glBindBuffer(GL_ARRAY_BUFFER, VBO);
		glBufferData(GL_ARRAY_BUFFER, GLfloat.sizeof, null, GL_DYNAMIC_DRAW);
		glEnableVertexAttribArray(0);
		glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, GLfloat.sizeof * 3, cast(void*)0);

		if (windowID !in mapPrograms)
			loadMapShader();
		glOrtho(windowObj.sizeX, windowObj.sizeY, windowID);
		if (windowID !in registeredOrtho) {
			orthoUpdates[windowID] ~= &glOrtho;
			registeredOrtho[windowID] = true;
		}
	}

	private static GLuint[UUID] mapPrograms;

	private void loadMapShader() {
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
		mapPrograms[windowID] = glCreateProgram();
		glAttachShader(mapPrograms[windowID], vertexShader);
		glAttachShader(mapPrograms[windowID], fragmentShader);
		glLinkProgram(mapPrograms[windowID]);
		glGetProgramiv(mapPrograms[windowID], GL_LINK_STATUS, &success);
		if (!success)
			throw new Exception("Linking Shader Error");
		glDeleteShader(vertexShader);
		glDeleteShader(fragmentShader);
	}

	public override nothrow void glOrtho(GLdouble width, GLdouble height, UUID winID) {
		initProj(winID);
		projMatrices[winID][0] = 2.0f/(width);
		projMatrices[winID][5] = 2.0f/(height);
		glUseProgram(mapPrograms[windowID]);
		glUniformMatrix4fv(glGetUniformLocation(mapPrograms[winID], "proj"), 1, GL_FALSE, &projMatrices[winID][0]);
		if (winID in shaderPrograms)
			glUseProgram(shaderPrograms[winID]);
	}

	protected Planet[] planets;
	protected Star sun;
	private immutable float planetSize = 8f;
	private int circleSegmentCount = 180;

	public nothrow void setData(SolarSystem data) {
		planets = data.getPlanets();
		sun = data.getSun();
		centerX = 0;
		centerY = 0;
		zoomAmount = .8f;
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

	protected float centerX = 0, centerY = 0;
	protected float zoomAmount = .8f;

	protected RenderButton[] planetCoords;
	protected float[] orbitRings;

	protected float colorR = Colors.Patina.red, colorG = Colors.Patina.green, colorB = Colors.Patina.blue;

	public nothrow override void render() {
		if (!visible)
			return;
		if (updateVertices) {
			import std.math;
			planetCoords.length = planets.length + 1;
			float maxDist = 0;
			foreach(Planet p; planets)
				if (p.getRadius() > maxDist)
					maxDist = p.getRadius();

			float radMult = (getWidth() > getHeight()) ? getHeight() / maxDist * zoomAmount : getWidth() / maxDist * zoomAmount;

			foreach(int i, Planet p; planets) {
				float pRx = cos(p.getAngle() / 360 * PI * 2) * p.getRadius() * radMult, pRy = sin(p.getAngle() / 360 * PI * 2) * p.getRadius() * radMult;		//polar to rect	
				try {
					planetCoords[i] = new RenderButton(xPos - centerX + pRx, yPos - centerY + pRy, .2f, planetSize, planetSize, "jupiter.png", window);
					planetCoords[i].setClick(genDel!Planet(p));
				} catch (Exception e) { assert(0); }
			}
			try {
				planetCoords[planetCoords.length - 1] = new RenderButton(xPos - centerX, yPos - centerY, .1f, sun.getRadius() * radMult, sun.getRadius() * radMult, "sun.png", window);
				planetCoords[planetCoords.length - 1].setClick(genDel!Star(sun));
			} catch (Exception) { assert(0); }

			//Generate the line rings for each planet
			orbitRings.length = 0;
			foreach(Planet p; planets) {
				float r = p.getRadius() * radMult;
				float theta = 2f * PI / cast(float)(circleSegmentCount - 1);
				float c = cos(theta);
				float s = sin(theta);
				float t;
				float x = r;
				float y = 0;
				for(int i = 0; i < circleSegmentCount; i++) {
					orbitRings ~= [xPos - centerX + x, yPos - centerY + y, .8f];
					t = x;
					x = c * x - s * y;
					y = s * t + c * y;
				}
			}
			glBindBuffer(GL_ARRAY_BUFFER, VBO);
			glBufferData(GL_ARRAY_BUFFER, cast(int)float.sizeof * orbitRings.length, orbitRings.ptr, GL_DYNAMIC_DRAW);
			

			updateVertices = false;
		}
		glUseProgram(mapPrograms[windowID]);
		glUniform3f(glGetUniformLocation(mapPrograms[windowID], "lineColor"), colorR, colorG, colorB);
		glBindVertexArray(VAO);
		glBindBuffer(GL_ARRAY_BUFFER, VBO);

		for(int i = 0; i < planets.length; i++) {
			glDrawArrays(GL_LINE_STRIP, i * circleSegmentCount, circleSegmentCount);
		}

		if (windowID in shaderPrograms)
			glUseProgram(shaderPrograms[windowID]);
		foreach(RenderObject o; planetCoords) {
			o.render();
		}
	}

	public override void onDestroy() {
		glDeleteBuffers(1, &VBO);
		glDeleteVertexArrays(1, &VAO);
	}

	
	private nothrow void delegate() nothrow genDel(T)(T p) {
		import render.window.WindowLoop;
		import render.window.PropertyWindow;
		import derelict.glfw3;
		return () nothrow {
			try {
				int x, y, top, bottom;
				glfwGetWindowPos(window.getGLFW(), &x, &y);
				glfwGetWindowFrameSize(window.getGLFW(), null, &top, null, &bottom);
				PropertyWindow!T w = new PropertyWindow!T(p);
				x = cast(int)(x + (window.cursorXPos + window.sizeX / 2) - w.sizeX / 2);
				y = cast(int)(y + (window.sizeY / 2 - window.cursorYPos) - w.sizeY / 2);
				glfwSetWindowPos(w.getGLFW(), (x > 0) ? x : 0, (y > top) ? y : top);
				AddWindow(w);
			} catch (Exception) { assert(0); }
		};
	}
	
}
