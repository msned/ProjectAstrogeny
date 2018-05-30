module render.screenComponents.Text;

import derelict.opengl;
import render.RenderObject;
import render.window.WindowObject;
import render.Fonts;
import std.uuid;

class RenderText : RenderObject {

	string displayText;
	float scale;

	const static char* vertexShaderSource = 
		"#version 330 core
		layout (location = 0) in vec4 vertex; // <vec2 pos, vec2 tex>
		out vec2 TexCoords;

		uniform mat4 proj;

		void main()
		{
		gl_Position = proj * vec4(vertex.xy, 0.0, 1.0);
		TexCoords = vertex.zw;
		}";
	const static char* fragmentShaderSource = 
		"#version 330 core
		in vec2 TexCoords;
		out vec4 color;

		uniform sampler2D text;
		uniform vec3 textColor;

		void main()
		{    
		vec4 sampled = vec4(1.0, 1.0, 1.0, texture(text, TexCoords).r);
		color = vec4(textColor, 1.0) * sampled;
		} ";

	this(string displayText, float x, float y, float scale, WindowObject windowObj) {
		super.xPos = x;
		super.yPos = y;
		this.scale = scale;
		this.displayText = displayText;
		windowID = windowObj.windowID;
		glGenVertexArrays(1, &VAO);
		glGenBuffers(1, &VBO);
		glBindVertexArray(VAO);
		glBindBuffer(GL_ARRAY_BUFFER, VBO);
		glBufferData(GL_ARRAY_BUFFER, GLfloat.sizeof * 6 * 4, null, GL_DYNAMIC_DRAW);
		glEnableVertexAttribArray(0);
		glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 4 * GLfloat.sizeof, cast(void*)0);
		glBindBuffer(GL_ARRAY_BUFFER, 0);

		if (!(windowID in textPrograms))
			loadTextShader();
		glUseProgram(textPrograms[windowID]);
		glOrtho(0, windowObj.sizeX, 0, windowObj.sizeY, -10, 10, windowID);
		orthoUpdated[windowID] = false;
		glUniformMatrix4fv(glGetUniformLocation(textPrograms[windowID], "proj"), 1, GL_FALSE, &projMatrices[windowID][0]);
	}

	protected float colorR = 106 /255f, colorG = 126 /255f, colorB = 255 /255f;

	/++
	Sets the color of the text to RGB values from 0 to 255
	++/
	public void setColor(float r, float g, float b) {
		colorR = r / 255;
		colorG = g / 255;
		colorB = b / 255;
	}


	protected GLfloat[4][6] vert;

	static GLuint[UUID] textPrograms;

	/++
	Returns the number of pixels needed to render the current string of text
	++/
	public GLuint getTextLength() {
		GLuint total = 0;
		foreach(char c; displayText) {
			Character ch = Characters[c];
			total += ch.Advance >> 6;
		}
		return total;
	}

	private void loadTextShader() {
		
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
		textPrograms[windowID] = glCreateProgram();
		glAttachShader(textPrograms[windowID], vertexShader);
		glAttachShader(textPrograms[windowID], fragmentShader);
		glLinkProgram(textPrograms[windowID]);
		glGetProgramiv(textPrograms[windowID], GL_LINK_STATUS, &success);
		if (!success)
			throw new Exception("Linking Shader Error");

		glDeleteShader(vertexShader);
		glDeleteShader(fragmentShader);
	}

	private static bool[UUID] orthoUpdated;

	override void render() {
		glUseProgram(textPrograms[windowID]);
		if (updateOrtho[windowID]) {
			if (!orthoUpdated[windowID]) {
				glUniformMatrix4fv(glGetUniformLocation(textPrograms[windowID], "proj"), 1, GL_FALSE, &projMatrices[windowID][0]);
				orthoUpdated[windowID] = true;
			}
		} else {
			if (orthoUpdated[windowID])
				orthoUpdated[windowID] = false;
		}

		glUniform3f(glGetUniformLocation(textPrograms[windowID], "textColor"), colorR, colorG, colorB);

		glBindVertexArray(VAO);

		float xOffset = 0;
		foreach(char c; displayText) {
			Character ch = Characters[c];

			float xP = xPos + ch.xBearing * scale + xOffset;
			float yP = yPos - (ch.ySize - ch.yBearing) * scale;
			float w = ch.xSize * scale;
			float h = ch.ySize * scale;

			vert = [
				[xP, yP+h,	0.0, 0.0],
				[xP, yP,	0.0, 1.0],
				[xP+w, yP,	1.0, 1.0],

				[xP, yP+h,	0.0, 0.0],
				[xP+w, yP,	1.0, 1.0],
				[xP+w, yP+h, 1.0, 0.0]
			];

			glBindTexture(GL_TEXTURE_2D, ch.TextureID);
			glBindBuffer(GL_ARRAY_BUFFER, VBO);
			glBufferSubData(GL_ARRAY_BUFFER, 0, cast(int)vert.sizeof, &vert[0]);
			glDrawArrays(GL_TRIANGLES, 0, 6);

			xOffset += (ch.Advance >> 6) * scale;
		}
	}

}
