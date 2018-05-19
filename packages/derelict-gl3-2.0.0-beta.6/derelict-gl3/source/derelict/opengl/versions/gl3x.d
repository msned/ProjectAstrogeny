/*

Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

*/
module derelict.opengl.versions.gl3x;

import derelict.opengl.types;
public
import derelict.opengl.extensions.core_30,
       derelict.opengl.extensions.core_31,
       derelict.opengl.extensions.core_32,
       derelict.opengl.extensions.core_33;

enum _gl30Decls =
q{
enum : uint {
    GL_COMPARE_REF_TO_TEXTURE         = 0x884E,
    GL_CLIP_DISTANCE0                 = 0x3000,
    GL_CLIP_DISTANCE1                 = 0x3001,
    GL_CLIP_DISTANCE2                 = 0x3002,
    GL_CLIP_DISTANCE3                 = 0x3003,
    GL_CLIP_DISTANCE4                 = 0x3004,
    GL_CLIP_DISTANCE5                 = 0x3005,
    GL_CLIP_DISTANCE6                 = 0x3006,
    GL_CLIP_DISTANCE7                 = 0x3007,
    GL_MAX_CLIP_DISTANCES             = 0x0D32,
    GL_MAJOR_VERSION                  = 0x821B,
    GL_MINOR_VERSION                  = 0x821C,
    GL_NUM_EXTENSIONS                 = 0x821D,
    GL_CONTEXT_FLAGS                  = 0x821E,
    GL_COMPRESSED_RED                 = 0x8225,
    GL_COMPRESSED_RG                  = 0x8226,
    GL_CONTEXT_FLAG_FORWARD_COMPATIBLE_BIT = 0x0001,
    GL_RGBA32F                        = 0x8814,
    GL_RGB32F                         = 0x8815,
    GL_RGBA16F                        = 0x881A,
    GL_RGB16F                         = 0x881B,
    GL_VERTEX_ATTRIB_ARRAY_INTEGER    = 0x88FD,
    GL_MAX_ARRAY_TEXTURE_LAYERS       = 0x88FF,
    GL_MIN_PROGRAM_TEXEL_OFFSET       = 0x8904,
    GL_MAX_PROGRAM_TEXEL_OFFSET       = 0x8905,
    GL_CLAMP_READ_COLOR               = 0x891C,
    GL_FIXED_ONLY                     = 0x891D,
    GL_MAX_VARYING_COMPONENTS         = 0x8B4B,
    GL_TEXTURE_1D_ARRAY               = 0x8C18,
    GL_PROXY_TEXTURE_1D_ARRAY         = 0x8C19,
    GL_TEXTURE_2D_ARRAY               = 0x8C1A,
    GL_PROXY_TEXTURE_2D_ARRAY         = 0x8C1B,
    GL_TEXTURE_BINDING_1D_ARRAY       = 0x8C1C,
    GL_TEXTURE_BINDING_2D_ARRAY       = 0x8C1D,
    GL_R11F_G11F_B10F                 = 0x8C3A,
    GL_UNSIGNED_INT_10F_11F_11F_REV   = 0x8C3B,
    GL_RGB9_E5                        = 0x8C3D,
    GL_UNSIGNED_INT_5_9_9_9_REV       = 0x8C3E,
    GL_TEXTURE_SHARED_SIZE            = 0x8C3F,
    GL_TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH = 0x8C76,
    GL_TRANSFORM_FEEDBACK_BUFFER_MODE = 0x8C7F,
    GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS = 0x8C80,
    GL_TRANSFORM_FEEDBACK_VARYINGS    = 0x8C83,
    GL_TRANSFORM_FEEDBACK_BUFFER_START = 0x8C84,
    GL_TRANSFORM_FEEDBACK_BUFFER_SIZE = 0x8C85,
    GL_PRIMITIVES_GENERATED           = 0x8C87,
    GL_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN = 0x8C88,
    GL_RASTERIZER_DISCARD             = 0x8C89,
    GL_MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS = 0x8C8A,
    GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS = 0x8C8B,
    GL_INTERLEAVED_ATTRIBS            = 0x8C8C,
    GL_SEPARATE_ATTRIBS               = 0x8C8D,
    GL_TRANSFORM_FEEDBACK_BUFFER      = 0x8C8E,
    GL_TRANSFORM_FEEDBACK_BUFFER_BINDING = 0x8C8F,
    GL_RGBA32UI                       = 0x8D70,
    GL_RGB32UI                        = 0x8D71,
    GL_RGBA16UI                       = 0x8D76,
    GL_RGB16UI                        = 0x8D77,
    GL_RGBA8UI                        = 0x8D7C,
    GL_RGB8UI                         = 0x8D7D,
    GL_RGBA32I                        = 0x8D82,
    GL_RGB32I                         = 0x8D83,
    GL_RGBA16I                        = 0x8D88,
    GL_RGB16I                         = 0x8D89,
    GL_RGBA8I                         = 0x8D8E,
    GL_RGB8I                          = 0x8D8F,
    GL_RED_INTEGER                    = 0x8D94,
    GL_GREEN_INTEGER                  = 0x8D95,
    GL_BLUE_INTEGER                   = 0x8D96,
    GL_RGB_INTEGER                    = 0x8D98,
    GL_RGBA_INTEGER                   = 0x8D99,
    GL_BGR_INTEGER                    = 0x8D9A,
    GL_BGRA_INTEGER                   = 0x8D9B,
    GL_SAMPLER_1D_ARRAY               = 0x8DC0,
    GL_SAMPLER_2D_ARRAY               = 0x8DC1,
    GL_SAMPLER_1D_ARRAY_SHADOW        = 0x8DC3,
    GL_SAMPLER_2D_ARRAY_SHADOW        = 0x8DC4,
    GL_SAMPLER_CUBE_SHADOW            = 0x8DC5,
    GL_UNSIGNED_INT_VEC2              = 0x8DC6,
    GL_UNSIGNED_INT_VEC3              = 0x8DC7,
    GL_UNSIGNED_INT_VEC4              = 0x8DC8,
    GL_INT_SAMPLER_1D                 = 0x8DC9,
    GL_INT_SAMPLER_2D                 = 0x8DCA,
    GL_INT_SAMPLER_3D                 = 0x8DCB,
    GL_INT_SAMPLER_CUBE               = 0x8DCC,
    GL_INT_SAMPLER_1D_ARRAY           = 0x8DCE,
    GL_INT_SAMPLER_2D_ARRAY           = 0x8DCF,
    GL_UNSIGNED_INT_SAMPLER_1D        = 0x8DD1,
    GL_UNSIGNED_INT_SAMPLER_2D        = 0x8DD2,
    GL_UNSIGNED_INT_SAMPLER_3D        = 0x8DD3,
    GL_UNSIGNED_INT_SAMPLER_CUBE      = 0x8DD4,
    GL_UNSIGNED_INT_SAMPLER_1D_ARRAY  = 0x8DD6,
    GL_UNSIGNED_INT_SAMPLER_2D_ARRAY  = 0x8DD7,
    GL_QUERY_WAIT                     = 0x8E13,
    GL_QUERY_NO_WAIT                  = 0x8E14,
    GL_QUERY_BY_REGION_WAIT           = 0x8E15,
    GL_QUERY_BY_REGION_NO_WAIT        = 0x8E16,
    GL_BUFFER_ACCESS_FLAGS            = 0x911F,
    GL_BUFFER_MAP_LENGTH              = 0x9120,
    GL_BUFFER_MAP_OFFSET              = 0x9121,
}
extern(System) @nogc nothrow {
    alias da_glColorMaski = void function(GLuint,GLboolean,GLboolean,GLboolean,GLboolean);
    alias da_glGetBooleani_v = void function(GLenum,GLuint,GLboolean*);
    alias da_glGetIntegeri_v = void function(GLenum,GLuint,GLint*);
    alias da_glEnablei = void function(GLenum,GLuint);
    alias da_glDisablei = void function(GLenum,GLuint);
    alias da_glIsEnabledi = GLboolean function(GLenum,GLuint);
    alias da_glBeginTransformFeedback = void function(GLenum);
    alias da_glEndTransformFeedback = void function();
    alias da_glBindBufferRange = void function(GLenum,GLuint,GLuint,GLintptr,GLsizeiptr);
    alias da_glBindBufferBase = void function(GLenum,GLuint,GLuint);
    alias da_glTransformFeedbackVaryings = void function(GLuint,GLsizei,const(GLchar*)*,GLenum);
    alias da_glGetTransformFeedbackVarying = void function(GLuint,GLuint,GLsizei,GLsizei*,GLsizei*,GLenum*,GLchar*);
    alias da_glClampColor = void function(GLenum,GLenum);
    alias da_glBeginConditionalRender = void function(GLuint,GLenum);
    alias da_glEndConditionalRender = void function();
    alias da_glVertexAttribIPointer = void function(GLuint,GLint,GLenum,GLsizei,const(GLvoid)*);
    alias da_glGetVertexAttribIiv = void function(GLuint,GLenum,GLint*);
    alias da_glGetVertexAttribIuiv = void function(GLuint,GLenum,GLuint*);
    alias da_glVertexAttribI1i = void function(GLuint,GLint);
    alias da_glVertexAttribI2i = void function(GLuint,GLint,GLint);
    alias da_glVertexAttribI3i = void function(GLuint,GLint,GLint,GLint);
    alias da_glVertexAttribI4i = void function(GLuint,GLint,GLint,GLint,GLint);
    alias da_glVertexAttribI1ui = void function(GLuint,GLuint);
    alias da_glVertexAttribI2ui = void function(GLuint,GLuint,GLuint);
    alias da_glVertexAttribI3ui = void function(GLuint,GLuint,GLuint,GLuint);
    alias da_glVertexAttribI4ui = void function(GLuint,GLuint,GLuint,GLuint,GLuint);
    alias da_glVertexAttribI1iv = void function(GLuint,const(GLint)*);
    alias da_glVertexAttribI2iv = void function(GLuint,const(GLint)*);
    alias da_glVertexAttribI3iv = void function(GLuint,const(GLint)*);
    alias da_glVertexAttribI4iv = void function(GLuint,const(GLint)*);
    alias da_glVertexAttribI1uiv = void function(GLuint,const(GLuint)*);
    alias da_glVertexAttribI2uiv = void function(GLuint,const(GLuint)*);
    alias da_glVertexAttribI3uiv = void function(GLuint,const(GLuint)*);
    alias da_glVertexAttribI4uiv = void function(GLuint,const(GLuint)*);
    alias da_glVertexAttribI4bv = void function(GLuint,const(GLbyte)*);
    alias da_glVertexAttribI4sv = void function(GLuint,const(GLshort)*);
    alias da_glVertexAttribI4ubv = void function(GLuint,const(GLubyte)*);
    alias da_glVertexAttribI4usv = void function(GLuint,const(GLushort)*);
    alias da_glGetUniformuiv = void function(GLuint,GLint,GLuint*);
    alias da_glBindFragDataLocation = void function(GLuint,GLuint,const(GLchar)*);
    alias da_glGetFragDataLocation = GLint function(GLuint,const(GLchar)*);
    alias da_glUniform1ui = void function(GLint,GLuint);
    alias da_glUniform2ui = void function(GLint,GLuint,GLuint);
    alias da_glUniform3ui = void function(GLint,GLuint,GLuint,GLuint);
    alias da_glUniform4ui = void function(GLint,GLuint,GLuint,GLuint,GLuint);
    alias da_glUniform1uiv = void function(GLint,GLsizei,const(GLuint)*);
    alias da_glUniform2uiv = void function(GLint,GLsizei,const(GLuint)*);
    alias da_glUniform3uiv = void function(GLint,GLsizei,const(GLuint)*);
    alias da_glUniform4uiv = void function(GLint,GLsizei,const(GLuint)*);
    alias da_glTexParameterIiv = void function(GLenum,GLenum,const(GLint)*);
    alias da_glTexParameterIuiv = void function(GLenum,GLenum,const(GLuint)*);
    alias da_glGetTexParameterIiv = void function(GLenum,GLenum,GLint*);
    alias da_glGetTexParameterIuiv = void function(GLenum,GLenum,GLuint*);
    alias da_glClearBufferiv = void function(GLenum,GLint,const(GLint)*);
    alias da_glClearBufferuiv = void function(GLenum,GLint,const(GLuint)*);
    alias da_glClearBufferfv = void function(GLenum,GLint,const(GLfloat)*);
    alias da_glClearBufferfi = void function(GLenum,GLint,GLfloat,GLint);
    alias da_glGetStringi = const(char)* function(GLenum,GLuint);
}};
enum gl30Decls = corearb30Decls ~ _gl30Decls;

enum _gl31Decls =
q{
enum : uint
{
    GL_SAMPLER_2D_RECT                = 0x8B63,
    GL_SAMPLER_2D_RECT_SHADOW         = 0x8B64,
    GL_SAMPLER_BUFFER                 = 0x8DC2,
    GL_INT_SAMPLER_2D_RECT            = 0x8DCD,
    GL_INT_SAMPLER_BUFFER             = 0x8DD0,
    GL_UNSIGNED_INT_SAMPLER_2D_RECT   = 0x8DD5,
    GL_UNSIGNED_INT_SAMPLER_BUFFER    = 0x8DD8,
    GL_TEXTURE_BUFFER                 = 0x8C2A,
    GL_MAX_TEXTURE_BUFFER_SIZE        = 0x8C2B,
    GL_TEXTURE_BINDING_BUFFER         = 0x8C2C,
    GL_TEXTURE_BUFFER_DATA_STORE_BINDING = 0x8C2D,
    GL_TEXTURE_BUFFER_FORMAT          = 0x8C2E,
    GL_TEXTURE_RECTANGLE              = 0x84F5,
    GL_TEXTURE_BINDING_RECTANGLE      = 0x84F6,
    GL_PROXY_TEXTURE_RECTANGLE        = 0x84F7,
    GL_MAX_RECTANGLE_TEXTURE_SIZE     = 0x84F8,
    GL_RED_SNORM                      = 0x8F90,
    GL_RG_SNORM                       = 0x8F91,
    GL_RGB_SNORM                      = 0x8F92,
    GL_RGBA_SNORM                     = 0x8F93,
    GL_R8_SNORM                       = 0x8F94,
    GL_RG8_SNORM                      = 0x8F95,
    GL_RGB8_SNORM                     = 0x8F96,
    GL_RGBA8_SNORM                    = 0x8F97,
    GL_R16_SNORM                      = 0x8F98,
    GL_RG16_SNORM                     = 0x8F99,
    GL_RGB16_SNORM                    = 0x8F9A,
    GL_RGBA16_SNORM                   = 0x8F9B,
    GL_SIGNED_NORMALIZED              = 0x8F9C,
    GL_PRIMITIVE_RESTART              = 0x8F9D,
    GL_PRIMITIVE_RESTART_INDEX        = 0x8F9E,
}
extern(System) @nogc nothrow {
    alias da_glDrawArraysInstanced = void function(GLenum,GLint,GLsizei,GLsizei);
    alias da_glDrawElementsInstanced = void function(GLenum,GLsizei,GLenum,const(GLvoid)*,GLsizei);
    alias da_glTexBuffer = void function(GLenum,GLenum,GLuint);
    alias da_glPrimitiveRestartIndex = void function(GLuint);
}};
enum gl31Decls = corearb31Decls ~ _gl31Decls;

enum _gl32Decls =
q{
enum : uint
{
    GL_CONTEXT_CORE_PROFILE_BIT       = 0x00000001,
    GL_CONTEXT_COMPATIBILITY_PROFILE_BIT = 0x00000002,
    GL_LINES_ADJACENCY                = 0x000A,
    GL_LINE_STRIP_ADJACENCY           = 0x000B,
    GL_TRIANGLES_ADJACENCY            = 0x000C,
    GL_TRIANGLE_STRIP_ADJACENCY       = 0x000D,
    GL_PROGRAM_POINT_SIZE             = 0x8642,
    GL_MAX_GEOMETRY_TEXTURE_IMAGE_UNITS = 0x8C29,
    GL_FRAMEBUFFER_ATTACHMENT_LAYERED = 0x8DA7,
    GL_FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS = 0x8DA8,
    GL_GEOMETRY_SHADER                = 0x8DD9,
    GL_GEOMETRY_VERTICES_OUT          = 0x8916,
    GL_GEOMETRY_INPUT_TYPE            = 0x8917,
    GL_GEOMETRY_OUTPUT_TYPE           = 0x8918,
    GL_MAX_GEOMETRY_UNIFORM_COMPONENTS = 0x8DDF,
    GL_MAX_GEOMETRY_OUTPUT_VERTICES   = 0x8DE0,
    GL_MAX_GEOMETRY_TOTAL_OUTPUT_COMPONENTS = 0x8DE1,
    GL_MAX_VERTEX_OUTPUT_COMPONENTS   = 0x9122,
    GL_MAX_GEOMETRY_INPUT_COMPONENTS  = 0x9123,
    GL_MAX_GEOMETRY_OUTPUT_COMPONENTS = 0x9124,
    GL_MAX_FRAGMENT_INPUT_COMPONENTS  = 0x9125,
    GL_CONTEXT_PROFILE_MASK           = 0x9126,
}
extern(System) @nogc nothrow {
    alias da_glGetInteger64i_v = void function(GLenum,GLuint,GLint64*);
    alias da_glGetBufferParameteri64v = void function(GLenum,GLenum,GLint64*);
    alias da_glFramebufferTexture = void function(GLenum,GLenum,GLuint,GLint);
}};
enum gl32Decls = corearb32Decls ~ _gl32Decls;

enum _gl33Decls =
q{
enum uint GL_VERTEX_ATTRIB_ARRAY_DIVISOR = 0x88FE;
extern(System) @nogc nothrow {
    alias da_glVertexAttribDivisor = void function(GLuint,GLuint);
}};
enum gl33Decls = corearb33Decls ~ _gl33Decls;

enum _gl30Funcs =
q{
    da_glColorMaski glColorMaski;
    da_glGetBooleani_v glGetBooleani_v;
    da_glGetIntegeri_v glGetIntegeri_v;
    da_glEnablei glEnablei;
    da_glDisablei glDisablei;
    da_glIsEnabledi glIsEnabledi;
    da_glBeginTransformFeedback glBeginTransformFeedback;
    da_glEndTransformFeedback glEndTransformFeedback;
    da_glBindBufferRange glBindBufferRange;
    da_glBindBufferBase glBindBufferBase;
    da_glTransformFeedbackVaryings glTransformFeedbackVaryings;
    da_glGetTransformFeedbackVarying glGetTransformFeedbackVarying;
    da_glClampColor glClampColor;
    da_glBeginConditionalRender glBeginConditionalRender;
    da_glEndConditionalRender glEndConditionalRender;
    da_glVertexAttribIPointer glVertexAttribIPointer;
    da_glGetVertexAttribIiv glGetVertexAttribIiv;
    da_glGetVertexAttribIuiv glGetVertexAttribIuiv;
    da_glVertexAttribI1i glVertexAttribI1i;
    da_glVertexAttribI2i glVertexAttribI2i;
    da_glVertexAttribI3i glVertexAttribI3i;
    da_glVertexAttribI4i glVertexAttribI4i;
    da_glVertexAttribI1ui glVertexAttribI1ui;
    da_glVertexAttribI2ui glVertexAttribI2ui;
    da_glVertexAttribI3ui glVertexAttribI3ui;
    da_glVertexAttribI4ui glVertexAttribI4ui;
    da_glVertexAttribI1iv glVertexAttribI1iv;
    da_glVertexAttribI2iv glVertexAttribI2iv;
    da_glVertexAttribI3iv glVertexAttribI3iv;
    da_glVertexAttribI4iv glVertexAttribI4iv;
    da_glVertexAttribI1uiv glVertexAttribI1uiv;
    da_glVertexAttribI2uiv glVertexAttribI2uiv;
    da_glVertexAttribI3uiv glVertexAttribI3uiv;
    da_glVertexAttribI4uiv glVertexAttribI4uiv;
    da_glVertexAttribI4bv glVertexAttribI4bv;
    da_glVertexAttribI4sv glVertexAttribI4sv;
    da_glVertexAttribI4ubv glVertexAttribI4ubv;
    da_glVertexAttribI4usv glVertexAttribI4usv;
    da_glGetUniformuiv glGetUniformuiv;
    da_glBindFragDataLocation glBindFragDataLocation;
    da_glGetFragDataLocation glGetFragDataLocation;
    da_glUniform1ui glUniform1ui;
    da_glUniform2ui glUniform2ui;
    da_glUniform3ui glUniform3ui;
    da_glUniform4ui glUniform4ui;
    da_glUniform1uiv glUniform1uiv;
    da_glUniform2uiv glUniform2uiv;
    da_glUniform3uiv glUniform3uiv;
    da_glUniform4uiv glUniform4uiv;
    da_glTexParameterIiv glTexParameterIiv;
    da_glTexParameterIuiv glTexParameterIuiv;
    da_glGetTexParameterIiv glGetTexParameterIiv;
    da_glGetTexParameterIuiv glGetTexParameterIuiv;
    da_glClearBufferiv glClearBufferiv;
    da_glClearBufferuiv glClearBufferuiv;
    da_glClearBufferfv glClearBufferfv;
    da_glClearBufferfi glClearBufferfi;
    da_glGetStringi glGetStringi;
};
enum gl30Funcs = corearb30Funcs ~ _gl30Funcs;

enum _gl31Funcs =
q{
    da_glDrawArraysInstanced glDrawArraysInstanced;
    da_glDrawElementsInstanced glDrawElementsInstanced;
    da_glTexBuffer glTexBuffer;
    da_glPrimitiveRestartIndex glPrimitiveRestartIndex;
};
enum gl31Funcs = corearb31Funcs ~ _gl31Funcs;

enum _gl32Funcs =
q{
    da_glGetInteger64i_v glGetInteger64i_v;
    da_glGetBufferParameteri64v glGetBufferParameteri64v;
    da_glFramebufferTexture glFramebufferTexture;
};
enum gl32Funcs = corearb32Funcs ~ _gl32Funcs;

enum _gl33Funcs =
q{
    da_glVertexAttribDivisor glVertexAttribDivisor;
};
enum gl33Funcs = corearb33Funcs ~ _gl33Funcs;

enum _gl30Loader =
q{
    bindGLFunc(cast(void**)&glColorMaski, "glColorMaski");
    bindGLFunc(cast(void**)&glGetBooleani_v, "glGetBooleani_v");
    bindGLFunc(cast(void**)&glGetIntegeri_v, "glGetIntegeri_v");
    bindGLFunc(cast(void**)&glEnablei, "glEnablei");
    bindGLFunc(cast(void**)&glDisablei, "glDisablei");
    bindGLFunc(cast(void**)&glIsEnabledi, "glIsEnabledi");
    bindGLFunc(cast(void**)&glBeginTransformFeedback, "glBeginTransformFeedback");
    bindGLFunc(cast(void**)&glEndTransformFeedback, "glEndTransformFeedback");
    bindGLFunc(cast(void**)&glBindBufferRange, "glBindBufferRange");
    bindGLFunc(cast(void**)&glBindBufferBase, "glBindBufferBase");
    bindGLFunc(cast(void**)&glTransformFeedbackVaryings, "glTransformFeedbackVaryings");
    bindGLFunc(cast(void**)&glGetTransformFeedbackVarying, "glGetTransformFeedbackVarying");
    bindGLFunc(cast(void**)&glClampColor, "glClampColor");
    bindGLFunc(cast(void**)&glBeginConditionalRender, "glBeginConditionalRender");
    bindGLFunc(cast(void**)&glEndConditionalRender, "glEndConditionalRender");
    bindGLFunc(cast(void**)&glVertexAttribIPointer, "glVertexAttribIPointer");
    bindGLFunc(cast(void**)&glGetVertexAttribIiv, "glGetVertexAttribIiv");
    bindGLFunc(cast(void**)&glGetVertexAttribIuiv, "glGetVertexAttribIuiv");
    bindGLFunc(cast(void**)&glVertexAttribI1i, "glVertexAttribI1i");
    bindGLFunc(cast(void**)&glVertexAttribI2i, "glVertexAttribI2i");
    bindGLFunc(cast(void**)&glVertexAttribI3i, "glVertexAttribI3i");
    bindGLFunc(cast(void**)&glVertexAttribI4i, "glVertexAttribI4i");
    bindGLFunc(cast(void**)&glVertexAttribI1ui, "glVertexAttribI1ui");
    bindGLFunc(cast(void**)&glVertexAttribI2ui, "glVertexAttribI2ui");
    bindGLFunc(cast(void**)&glVertexAttribI3ui, "glVertexAttribI3ui");
    bindGLFunc(cast(void**)&glVertexAttribI4ui, "glVertexAttribI4ui");
    bindGLFunc(cast(void**)&glVertexAttribI1iv, "glVertexAttribI1iv");
    bindGLFunc(cast(void**)&glVertexAttribI2iv, "glVertexAttribI2iv");
    bindGLFunc(cast(void**)&glVertexAttribI3iv, "glVertexAttribI3iv");
    bindGLFunc(cast(void**)&glVertexAttribI4iv, "glVertexAttribI4iv");
    bindGLFunc(cast(void**)&glVertexAttribI1uiv, "glVertexAttribI1uiv");
    bindGLFunc(cast(void**)&glVertexAttribI2uiv, "glVertexAttribI2uiv");
    bindGLFunc(cast(void**)&glVertexAttribI3uiv, "glVertexAttribI3uiv");
    bindGLFunc(cast(void**)&glVertexAttribI4uiv, "glVertexAttribI4uiv");
    bindGLFunc(cast(void**)&glVertexAttribI4bv, "glVertexAttribI4bv");
    bindGLFunc(cast(void**)&glVertexAttribI4sv, "glVertexAttribI4sv");
    bindGLFunc(cast(void**)&glVertexAttribI4ubv, "glVertexAttribI4ubv");
    bindGLFunc(cast(void**)&glVertexAttribI4usv, "glVertexAttribI4usv");
    bindGLFunc(cast(void**)&glGetUniformuiv, "glGetUniformuiv");
    bindGLFunc(cast(void**)&glBindFragDataLocation, "glBindFragDataLocation");
    bindGLFunc(cast(void**)&glGetFragDataLocation, "glGetFragDataLocation");
    bindGLFunc(cast(void**)&glUniform1ui, "glUniform1ui");
    bindGLFunc(cast(void**)&glUniform2ui, "glUniform2ui");
    bindGLFunc(cast(void**)&glUniform3ui, "glUniform3ui");
    bindGLFunc(cast(void**)&glUniform4ui, "glUniform4ui");
    bindGLFunc(cast(void**)&glUniform1uiv, "glUniform1uiv");
    bindGLFunc(cast(void**)&glUniform2uiv, "glUniform2uiv");
    bindGLFunc(cast(void**)&glUniform3uiv, "glUniform3uiv");
    bindGLFunc(cast(void**)&glUniform4uiv, "glUniform4uiv");
    bindGLFunc(cast(void**)&glTexParameterIiv, "glTexParameterIiv");
    bindGLFunc(cast(void**)&glTexParameterIuiv, "glTexParameterIuiv");
    bindGLFunc(cast(void**)&glGetTexParameterIiv, "glGetTexParameterIiv");
    bindGLFunc(cast(void**)&glGetTexParameterIuiv, "glGetTexParameterIuiv");
    bindGLFunc(cast(void**)&glClearBufferiv, "glClearBufferiv");
    bindGLFunc(cast(void**)&glClearBufferuiv, "glClearBufferuiv");
    bindGLFunc(cast(void**)&glClearBufferfv, "glClearBufferfv");
    bindGLFunc(cast(void**)&glClearBufferfi, "glClearBufferfi");
    bindGLFunc(cast(void**)&glGetStringi, "glGetStringi");
    glVer = GLVersion.gl30;
};
version(DerelictGL3_Contexts)
    enum _gl30LoaderAdd = corearb30Loader;
else
    enum _gl30LoaderAdd = `loadExtensionSet(GLVersion.gl30, true);`;
enum gl30Loader = `if(maxVer >= GLVersion.gl30) {` ~ _gl30LoaderAdd ~ _gl30Loader ~ `}`;

enum _gl31Loader =
q{
    bindGLFunc(cast(void**)&glDrawArraysInstanced, "glDrawArraysInstanced");
    bindGLFunc(cast(void**)&glDrawElementsInstanced, "glDrawElementsInstanced");
    bindGLFunc(cast(void**)&glTexBuffer, "glTexBuffer");
    bindGLFunc(cast(void**)&glPrimitiveRestartIndex, "glPrimitiveRestartIndex");
    glVer = GLVersion.gl31;
};
version(DerelictGL3_Contexts)
    enum _gl31LoaderAdd = corearb31Loader;
else
    enum _gl31LoaderAdd = `loadExtensionSet(GLVersion.gl31, true);`;
enum gl31Loader = `if(maxVer >= GLVersion.gl31) {` ~ _gl31LoaderAdd ~ _gl31Loader ~ `}`;

enum _gl32Loader =
q{
    bindGLFunc(cast(void**)&glGetInteger64i_v, "glGetInteger64i_v");
    bindGLFunc(cast(void**)&glGetBufferParameteri64v, "glGetBufferParameteri64v");
    bindGLFunc(cast(void**)&glFramebufferTexture, "glFramebufferTexture");
    glVer = GLVersion.gl32;
};
version(DerelictGL3_Contexts)
    enum _gl32LoaderAdd = corearb32Loader;
else
    enum _gl32LoaderAdd = `loadExtensionSet(GLVersion.gl32, true);`;
enum gl32Loader = `if(maxVer >= GLVersion.gl32) {` ~ _gl32LoaderAdd ~ _gl32Loader ~ `}`;

enum _gl33Loader =
q{
    bindGLFunc(cast(void**)&glVertexAttribDivisor, "glVertexAttribDivisor");
    glVer = GLVersion.gl33;
};
version(DerelictGL3_Contexts)
    enum _gl33LoaderAdd = corearb33Loader;
else
    enum _gl33LoaderAdd = `loadExtensionSet(GLVersion.gl33, true);`;
enum gl33Loader = `if(maxVer >= GLVersion.gl33) {` ~ _gl33LoaderAdd ~ _gl33Loader ~ `}`;