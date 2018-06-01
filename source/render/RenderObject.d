module render.RenderObject;

import derelict.opengl;
import render.TextureUtil;
import std.stdio;
import std.uuid;
import render.window.WindowObject;
import render.Fonts;

class RenderObject {

	GLuint texture = 0;

	const static char* vertexShader = 
		"#version 330 core
		layout (location = 0) in vec3 aPos;
		layout (location = 1) in vec3 aColor;
		layout (location = 2) in vec2 aTexCoord;
		uniform mat4 proj;

		out vec3 ourColor;
		out vec2 TexCoord;

		void main()
		{
		gl_Position = proj * vec4(aPos, 1.0);
		ourColor = aColor;
		TexCoord = vec2(aTexCoord.x, aTexCoord.y);
		}";
	const static char* fragmentShader = 
		"#version 330 core
		out vec4 FragColor;

		in vec3 ourColor;
		in vec2 TexCoord;

		// texture sampler
		uniform sampler2D texture1;

		void main()
		{
		FragColor = vec4(ourColor, 1.0) * texture(texture1, TexCoord);
		if (FragColor.a < 0.5)
			discard;
		}";

	protected float[32] vertices = [
		// positions				// colors				// texture coords
		10f,	-10f, 0.0f,		1.0f, 1.0f, 1.0f,		1.0f, 1.0f, // bottom right
		10f,	10f, 0.0f,		1.0f, 1.0f, 1.0f,		1.0f, 0.0f, // top right
        -10f,	10f, 0.0f,		1.0f, 1.0f, 1.0f,		0.0f, 0.0f, // top left
        -10f,  -10f, 0.0f,		1.0f, 1.0f, 1.0f,		0.0f, 1.0f  // bottom left 
    ];
	private uint[6] indices = [
		0,1,3,
		1,2,3
	];

	protected float xPos = 0, yPos = 0, depth = 0;
	protected float width = 30f, height = 30f;

	public nothrow float getXPos() {
		return xPos;
	}
	public nothrow float getYPos() {
		return yPos;
	}
	public nothrow float getWidth() {
		return width;
	}
	public nothrow float getHeight(){
		return height;
	}

	public void setColor(float red, float green, float blue) {
		vertices[3] = vertices[11] = vertices[19] = vertices[27] = red;
		vertices[4] = vertices[12] = vertices[20] = vertices[28] = green;
		vertices[5] = vertices[13] = vertices[21] = vertices[29] = blue;
		updateVertices = true;
	}

	/++
	Shifts the position of the quad by x and y in their respective directions
	Not to be confused with setPosition()
	+/
	public nothrow void shiftPosition(float x = 0, float y = 0) {
		vertices[0] += x;
		vertices[8] += x;
		vertices[16] += x;
		vertices[24] += x;
		vertices[1] += y;
		vertices[9] += y;
		vertices[17] += y;
		vertices[25] += y;
		xPos += x;
		yPos += y;
		updateVertices = true;
	}

	/++
	Sets the position of the quad at x and y values from the bottom left corner, uses current or default width and height
	Not to be confused with shiftPosition()
	++/
	public nothrow void setPosition(float x = 0, float y = 0) {
		vertices[0] = x + width;
		vertices[1] = y - height;
		vertices[8] = x + width;
		vertices[9] = y + height;
		vertices[16] = x - width;
		vertices[17] = y + height;
		vertices[24] = x - width;
		vertices[25] = y - height;
		this.xPos = x;
		this.yPos = y;
		updateVertices = true;
	}

	/++
	Sets the size of the window from 0 to 1 on each side x and y
	+/
	public nothrow void setScale(float width, float height) {
		this.width = width;
		this.height = height;
		setPosition(xPos, yPos);
	}

	public nothrow void setDepth(float depth) {
		vertices[2] = depth;
		vertices[10] = depth;
		vertices[18] = depth;
		vertices[26] = depth;
		this.depth = depth;
		updateVertices = true;
	}
	public float getDepth() {
		return depth;
	}

	protected bool updateVertices = false;
	public static bool[UUID] updateOrtho;
	private static bool[UUID] orthoUpdated;

	protected GLuint VBO, VAO;
	protected static GLuint EBO;
	protected static GLuint[UUID] shaderPrograms;
	protected static float[16][UUID] projMatrices;

	UUID windowID;
	
	this(string textureName, WindowObject windowObj) {
		texture = LoadTexture(textureName, windowObj.windowID);
		this(windowObj);
	}

	this(float xPos, float yPos, float depth, string textureName, WindowObject windowObj) {
		this(textureName, windowObj);
		setPosition(xPos, yPos);
		setDepth(depth);
	}

	this (float xPos, float yPos, float depth, float width, float height, string textureName, WindowObject windowObj) {
		setScale(width, height);
		this(xPos, yPos, depth, textureName, windowObj);
	}

	protected this() {}

	this(WindowObject windowObj) {
		
		windowID = windowObj.windowID;

		//GL texture stuff
		glGenVertexArrays(1, &VAO);
		glGenBuffers(1, &VBO);
		glGenBuffers(1, &EBO);

		glBindVertexArray(VAO);

		glBindBuffer(GL_ARRAY_BUFFER, VBO);
		glBufferData(GL_ARRAY_BUFFER, cast(int)vertices.sizeof, &vertices[0], GL_DYNAMIC_DRAW);

		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, cast(int)indices.sizeof, &indices[0], GL_STATIC_DRAW);

		glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 8 * float.sizeof, cast(void*)0);
		glEnableVertexAttribArray(0);

		glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 8 * float.sizeof, cast(void*)(3 * float.sizeof));
		glEnableVertexAttribArray(1);

		glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 8 * float.sizeof, cast(void*)(6 * float.sizeof));
		glEnableVertexAttribArray(2);
		glBindVertexArray(0);
		
		if (!(windowID in shaderPrograms))
			loadShader(vertexShader, fragmentShader);
		glUseProgram(shaderPrograms[windowID]);
		glOrtho(0, windowObj.sizeX, 0, windowObj.sizeY, -10, 10, windowID);
		orthoUpdated[windowID] = false;
		glUniformMatrix4fv(glGetUniformLocation(shaderPrograms[windowID], "proj"), 1, GL_FALSE, &projMatrices[windowID][0]);

	}
	void loadShader(const char* vertexShaderSource, const char* fragmentShaderSource) {

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
		shaderPrograms[windowID] = glCreateProgram();
		glAttachShader(shaderPrograms[windowID], vertexShader);
		glAttachShader(shaderPrograms[windowID], fragmentShader);
		glLinkProgram(shaderPrograms[windowID]);
		glGetProgramiv(shaderPrograms[windowID], GL_LINK_STATUS, &success);
		if (!success)
			throw new Exception("Linking Shader Error");

		glDeleteShader(vertexShader);
		glDeleteShader(fragmentShader);
	}

	private static nothrow void initProj(UUID winID) {
		projMatrices[winID] = [1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1];
	}
	static nothrow void glOrtho(GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble znear, GLdouble zfar, UUID winID) {
		initProj(winID);
		
		projMatrices[winID][0]  = 2.0f/(right - left);
		projMatrices[winID][5]  = 2.0f/(top - bottom);
		updateOrtho[winID] = true;
	}

	public static void onDestroyWindow(UUID winID) {
		glDeleteProgram(shaderPrograms[winID]);
		shaderPrograms.remove(winID);
		projMatrices.remove(winID);
	}

	public void onDestroy() {
		glDeleteBuffers(1, &VBO);
		glDeleteVertexArrays(1, &VAO);
	}

	private bool nineSlice = false;
	private float nineSliceBoarder;

	public void enableNineSlice(float boarder) {
		nineSliceBoarder = boarder;
		nineSlice = true;
	}

	public nothrow void render() {
		if (updateOrtho[windowID]) {
			if (!orthoUpdated[windowID]){
				glUniformMatrix4fv(glGetUniformLocation(shaderPrograms[windowID], "proj"), 1, GL_FALSE, &projMatrices[windowID][0]);
				orthoUpdated[windowID] = true;
			}
		} else {
			if (orthoUpdated[windowID])
				orthoUpdated[windowID] = false;
		}
		if (nineSlice) {
			nineSliceRender();
		} else {
			glBindTexture(GL_TEXTURE_2D, texture);
			glBindVertexArray(VAO);
			if (updateVertices) {
				glBindBuffer(GL_ARRAY_BUFFER, VBO);
				glBufferSubData(GL_ARRAY_BUFFER, 0, cast(int)vertices.sizeof, &vertices[0]);
				updateVertices = false;
			}
			glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, cast(void*)0);
		}
	}

	protected nothrow void nineSliceRender() {
		
	}
}
