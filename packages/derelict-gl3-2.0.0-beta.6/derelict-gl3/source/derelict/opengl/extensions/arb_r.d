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
module derelict.opengl.extensions.arb_r;

import derelict.opengl.types : usingContexts;
import derelict.opengl.extensions.internal;

// ARB_robust_buffer_access_behavior <-- Core in GL 4.3
enum ARB_robust_buffer_access_behavior = "GL_ARB_robust_buffer_access_behavior";
enum arbRobustBufferAccessBehaviorLoader = makeLoader(ARB_robust_buffer_access_behavior, "", "gl43");
static if(!usingContexts) enum arbRobustBufferAccessBehavior = arbRobustBufferAccessBehaviorLoader;

// ARB_robustness
enum ARB_robustness = "GL_ARB_robustness";
enum arbRobustnessDecls =
q{
enum : uint
{
    GL_CONTEXT_FLAG_ROBUST_ACCESS_BIT_ARB = 0x00000004,
    GL_LOSE_CONTEXT_ON_RESET_ARB      = 0x8252,
    GL_GUILTY_CONTEXT_RESET_ARB       = 0x8253,
    GL_INNOCENT_CONTEXT_RESET_ARB     = 0x8254,
    GL_UNKNOWN_CONTEXT_RESET_ARB      = 0x8255,
    GL_RESET_NOTIFICATION_STRATEGY_ARB = 0x8256,
    GL_NO_RESET_NOTIFICATION_ARB      = 0x8261,
}
extern(System) @nogc nothrow {
    alias da_glGetGraphicsResetStatusARB = GLenum function();
    alias da_glGetnMapdvARB = void function(GLenum, GLenum, GLsizei, GLdouble*);
    alias da_glGetnMapfvARB = void function(GLenum, GLenum, GLsizei, GLfloat*);
    alias da_glGetnMapivARB = void function(GLenum, GLenum, GLsizei, GLint*);
    alias da_glGetnPixelMapfvARB = void function(GLenum, GLsizei, GLfloat*);
    alias da_glGetnPixelMapuivARB = void function(GLenum, GLsizei, GLuint*);
    alias da_glGetnPixelMapusvARB = void function(GLenum, GLsizei, GLushort*);
    alias da_glGetnPolygonStippleARB = void function(GLsizei, GLubyte*);
    alias da_glGetnColorTableARB = void function(GLenum, GLenum, GLenum, GLsizei, GLvoid*);
    alias da_glGetnConvolutionFilterARB = void function(GLenum, GLenum, GLenum, GLsizei, GLvoid*);
    alias da_glGetnSeparableFilterARB = void function(GLenum, GLenum, GLenum, GLsizei, GLvoid*, GLsizei, GLvoid*, GLvoid*);
    alias da_glGetnHistogramARB = void function(GLenum, GLboolean, GLenum, GLenum, GLsizei, GLvoid*);
    alias da_glGetnMinmaxARB = void function(GLenum, GLboolean, GLenum, GLenum, GLsizei, GLvoid*);
    alias da_glGetnTexImageARB = void function(GLenum, GLint, GLenum, GLenum, GLsizei, GLvoid*);
    alias da_glReadnPixelsARB = void function(GLint, GLint, GLsizei, GLsizei, GLenum, GLenum, GLsizei, GLvoid*);
    alias da_glGetnCompressedTexImageARB = void function(GLenum, GLint, GLsizei, GLvoid*);
    alias da_glGetnUniformfvARB = void function(GLuint, GLint, GLsizei, GLfloat*);
    alias da_glGetnUniformivARB = void function(GLuint, GLint, GLsizei, GLint*);
    alias da_glGetnUniformuivARB = void function(GLuint, GLint, GLsizei, GLuint*);
    alias da_glGetnUniformdvARB = void function(GLuint, GLint, GLsizei, GLdouble*);
}};

enum arbRobustnessFuncs =
q{
    da_glGetGraphicsResetStatusARB glGetGraphicsResetStatusARB;
    da_glGetnMapdvARB glGetnMapdvARB;
    da_glGetnMapfvARB glGetnMapfvARB;
    da_glGetnMapivARB glGetnMapivARB;
    da_glGetnPixelMapfvARB glGetnPixelMapfvARB;
    da_glGetnPixelMapuivARB glGetnPixelMapuivARB;
    da_glGetnPixelMapusvARB glGetnPixelMapusvARB;
    da_glGetnPolygonStippleARB glGetnPolygonStippleARB;
    da_glGetnColorTableARB glGetnColorTableARB;
    da_glGetnConvolutionFilterARB glGetnConvolutionFilterARB;
    da_glGetnSeparableFilterARB glGetnSeparableFilterARB;
    da_glGetnHistogramARB glGetnHistogramARB;
    da_glGetnMinmaxARB glGetnMinmaxARB;
    da_glGetnTexImageARB glGetnTexImageARB;
    da_glReadnPixelsARB glReadnPixelsARB;
    da_glGetnCompressedTexImageARB glGetnCompressedTexImageARB;
    da_glGetnUniformfvARB glGetnUniformfvARB;
    da_glGetnUniformivARB glGetnUniformivARB;
    da_glGetnUniformuivARB glGetnUniformuivARB;
    da_glGetnUniformdvARB glGetnUniformdvARB;
};

enum arbRobustnessLoaderImpl =
q{
    bindGLFunc(cast(void**)&glGetGraphicsResetStatusARB, "glGetGraphicsResetStatusARB");
    bindGLFunc(cast(void**)&glGetnMapdvARB, "glGetnMapdvARB");
    bindGLFunc(cast(void**)&glGetnMapfvARB, "glGetnMapfvARB");
    bindGLFunc(cast(void**)&glGetnMapivARB, "glGetnMapivARB");
    bindGLFunc(cast(void**)&glGetnPixelMapfvARB, "glGetnPixelMapfvARB");
    bindGLFunc(cast(void**)&glGetnPixelMapuivARB, "glGetnPixelMapuivARB");
    bindGLFunc(cast(void**)&glGetnPixelMapusvARB, "glGetnPixelMapusvARB");
    bindGLFunc(cast(void**)&glGetnPolygonStippleARB, "glGetnPolygonStippleARB");
    bindGLFunc(cast(void**)&glGetnColorTableARB, "glGetnColorTableARB");
    bindGLFunc(cast(void**)&glGetnConvolutionFilterARB, "glGetnConvolutionFilterARB");
    bindGLFunc(cast(void**)&glGetnSeparableFilterARB, "glGetnSeparableFilterARB");
    bindGLFunc(cast(void**)&glGetnHistogramARB, "glGetnHistogramARB");
    bindGLFunc(cast(void**)&glGetnMinmaxARB, "glGetnMinmaxARB");
    bindGLFunc(cast(void**)&glGetnTexImageARB, "glGetnTexImageARB");
    bindGLFunc(cast(void**)&glReadnPixelsARB, "glReadnPixelsARB");
    bindGLFunc(cast(void**)&glGetnCompressedTexImageARB, "glGetnCompressedTexImageARB");
    bindGLFunc(cast(void**)&glGetnCompressedTexImageARB, "glGetnCompressedTexImageARB");
    bindGLFunc(cast(void**)&glGetnUniformfvARB, "glGetnUniformfvARB");
    bindGLFunc(cast(void**)&glGetnUniformivARB, "glGetnUniformivARB");
    bindGLFunc(cast(void**)&glGetnUniformuivARB, "glGetnUniformuivARB");
    bindGLFunc(cast(void**)&glGetnUniformdvARB, "glGetnUniformdvARB");
};

enum arbRobustnessLoader = makeExtLoader(ARB_robustness, arbRobustnessLoaderImpl);
static if(!usingContexts) enum arbRobustness = arbRobustnessDecls ~ arbRobustnessFuncs.makeGShared() ~ arbRobustnessLoader;

// ARB_robustness_isolation
enum ARB_robustness_isolation = "GL_ARB_robustness_isolation";
enum arbRobustnessIsolationLoader = makeExtLoader(ARB_robustness_isolation);
static if(!usingContexts) enum arbRobustnessIsolation = arbRobustnessIsolationLoader;