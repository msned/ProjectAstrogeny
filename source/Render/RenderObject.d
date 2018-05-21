module Render.RenderObject;
import derelict.opengl;
import Render.TextureUtil;
import std.stdio;
import std.uuid;

class RenderObject {

	GLuint texture = 0;

	const static char* vertexShaderSource = 
		"#version 330 core
		layout (location = 0) in vec3 aPos;
		layout (location = 1) in vec3 aColor;
		layout (location = 2) in vec2 aTexCoord;

		out vec3 ourColor;
		out vec2 TexCoord;

		void main()
		{
		gl_Position = vec4(aPos, 1.0);
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
		}";

	private float[32] vertices = [
		// positions			// colors				// texture coords
		0.5f,  0.5f, 0.0f,		1.0f, 0.0f, 0.0f,		1.0f, 1.0f, // top right
		0.5f, -0.5f, 0.0f,		0.0f, 1.0f, 0.0f,		1.0f, 0.0f, // bottom right
        -0.5f, -0.5f, 0.0f,		0.0f, 0.0f, 1.0f,		0.0f, 0.0f, // bottom left
        -0.5f,  0.5f, 0.0f,		1.0f, 1.0f, 0.0f,		0.0f, 1.0f  // top left 
    ];
	private uint[6] indices = [
		0,1,3,
		1,2,3
	];
	GLuint VBO, VAO, EBO;
	static int[UUID] shaderPrograms;

	UUID windowID;

	this(string textureName, UUID winid) {
		texture = LoadTexture(textureName);

		//GL texture stuff
		glGenVertexArrays(1, &VAO);
		glGenBuffers(1, &VBO);
		glGenBuffers(1, &EBO);

		glBindVertexArray(VAO);

		glBindBuffer(GL_ARRAY_BUFFER, VBO);
		glBufferData(GL_ARRAY_BUFFER, cast(int)vertices.sizeof, &vertices[0], GL_STATIC_DRAW);

		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, cast(int)indices.sizeof, &indices[0], GL_STATIC_DRAW);

		glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 8 * float.sizeof, cast(void*)0);
		glEnableVertexAttribArray(0);

		glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 8 * float.sizeof, cast(void*)(3 * float.sizeof));
		glEnableVertexAttribArray(1);

		glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 8 * float.sizeof, cast(void*)(6 * float.sizeof));
		glEnableVertexAttribArray(2);

		windowID = winid;
		
		if (!(winid in shaderPrograms))
			loadShader();
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

	public void render() {
		if (texture != 0) {
			glBindTexture(GL_TEXTURE_2D, texture);
			glUseProgram(shaderPrograms[windowID]);
			glBindVertexArray(VAO);
			glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, cast(void*)0);
		}
	}
}
