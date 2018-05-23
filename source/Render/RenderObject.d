module Render.RenderObject;
import derelict.opengl;
import Render.TextureUtil;
import std.stdio;
import std.uuid;
import Render.Window.WindowObject;

class RenderObject {

	GLuint texture = 0;

	const static char* vertexShaderSource = 
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
	const static char* fragmentShaderSource = 
		"#version 330 core
		out vec4 FragColor;

		in vec3 ourColor;
		in vec2 TexCoord;

		// texture sampler
		uniform sampler2D texture1;

		void main()
		{
		FragColor = texture(texture1, TexCoord);
		if (FragColor.a < 0.5)
			discard;
		}";

	private float[32] vertices = [
		// positions				// colors				// texture coords
		10f,	-10f, 0.0f,		1.0f, 0.0f, 0.0f,		1.0f, 1.0f, // bottom right
		10f,	10f, 0.0f,			0.0f, 1.0f, 0.0f,		1.0f, 0.0f, // top right
        -10f,	10f, 0.0f,			0.0f, 0.0f, 1.0f,		0.0f, 0.0f, // top left
        -10f,  -10f, 0.0f,		1.0f, 1.0f, 0.0f,		0.0f, 1.0f  // bottom left 
    ];
	private uint[6] indices = [
		0,1,3,
		1,2,3
	];

	private float xPos, yPos;
	private float width = 10f, height = 10f;

	public float getXPos() {
		return xPos;
	}
	public float getYPos() {
		return yPos;
	}
	public float getWidth() {
		return width;
	}
	public float getHeight(){
		return height;
	}

	/++
	Shifts the position of the quad by x and y in their respective directions
	+/
	public void ShiftPosition(float x = 0, float y = 0) {
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
	Sets the size of the window from 0 to 1 on each side x and y
	+/
	public void ScalePosition(float width, float height) {
		vertices[0] = width;
		vertices[8] = width;
		vertices[16] = -width;
		vertices[24] = -width;
		vertices[1] = -height;
		vertices[9] = height;
		vertices[17] = height;
		vertices[25] = -height;
		this.width = width;
		this.height = height;
		updateVertices = true;
	}

	public void SetDepth(float depth) {
		vertices[2] = depth;
		vertices[10] = depth;
		vertices[18] = depth;
		vertices[26] = depth;
		updateVertices = true;
	}

	private bool updateVertices = false;
	private static char updateOrtho = 0;

	GLuint VBO, VAO;
	static GLuint EBO;
	static GLuint[UUID] shaderPrograms;
	static float[16][UUID] projMatrices;

	UUID windowID;

	this(string textureName, WindowObject windowObj) {
		texture = LoadTexture(textureName, windowObj.windowID);

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

		windowID = windowObj.windowID;
		
		if (!(windowID in shaderPrograms))
			loadShader();
		glUseProgram(shaderPrograms[windowID]);
		initProj(windowID);
		glOrtho(0, windowObj.sizeX, 0, windowObj.sizeY, -10, 10, windowID);
		glUniformMatrix4fv(glGetUniformLocation(shaderPrograms[windowID], "proj"), 1, GL_FALSE, &projMatrices[windowID][0]);
	}
	void loadShader() {

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
		//projMatrices[winID][10] = -2.0f/(zfar - znear);
		//projMatrices[winID][12] = -(right + left)/(right - left);
		//projMatrices[winID][13] = -(top + bottom)/(top - bottom);
		//projMatrices[winID][14] = -(zfar + znear)/(zfar - znear);
		//projMatrices[winID][15] = 1.0f;
		updateOrtho = 2;
	}

	public static void onDestroyWindow(UUID winID) {
		glDeleteProgram(shaderPrograms[winID]);
		shaderPrograms.remove(winID);
		projMatrices.remove(winID);
	}

	public void onDestroy() {
		glDeleteBuffers(1, &EBO);
		glDeleteBuffers(1, &VBO);
		glDeleteVertexArrays(1, &VAO);
	}

	public void render() {
		if (texture != 0) {
			if (true) {		//TODO: Fix uniform not updating always
				//writeln("ortho");
				glUniformMatrix4fv(glGetUniformLocation(shaderPrograms[windowID], "proj"), 1, GL_FALSE, &projMatrices[windowID][0]);
				updateOrtho--;
			}
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
}
