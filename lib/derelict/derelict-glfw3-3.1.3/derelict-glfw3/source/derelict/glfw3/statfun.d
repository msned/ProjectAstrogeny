/*

Boost Software License - Version 1.0 - August 17th,2003

Permission is hereby granted,free of charge,to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use,reproduce,display,distribute,
execute,and transmit the Software,and to prepare derivative works of the
Software,and to permit third-parties to whom the Software is furnished to
do so,all subject to the following:

The copyright notices in the Software and this entire statement,including
the above license grant,this restriction and the following disclaimer,
must be included in all copies of the Software,in whole or in part,and
all derivative works of the Software,unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS",WITHOUT WARRANTY OF ANY KIND,EXPRESS OR
IMPLIED,INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE,TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY,WHETHER IN CONTRACT,TORT OR OTHERWISE,
ARISING FROM,OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

*/
module derelict.glfw3.statfun;

version(DerelictGLFW3Static):

public import derelict.glfw3.types;

extern(C) @nogc nothrow {
    int glfwInit();
    void glfwTerminate();
    void glfwGetVersion(int*,int*,int*);
    const(char)* glfwGetVersionString();
    GLFWerrorfun glfwSetErrorCallback(GLFWerrorfun);
    GLFWmonitor** glfwGetMonitors(int*);
    GLFWmonitor* glfwGetPrimaryMonitor();
    void glfwGetMonitorPos(GLFWmonitor*,int*,int*);
    void glfwGetMonitorPhysicalSize(GLFWmonitor*,int*,int*);
    const(char)* glfwGetMonitorName(GLFWmonitor*);
    GLFWmonitorfun glfwSetMonitorCallback(GLFWmonitorfun);
    const(GLFWvidmode)* glfwGetVideoModes(GLFWmonitor*,int*);
    const(GLFWvidmode)* glfwGetVideoMode(GLFWmonitor*);
    void glfwSetGamma(GLFWmonitor*,float);
    const(GLFWgammaramp*) glfwGetGammaRamp(GLFWmonitor*);
    void glfwSetGammaRamp(GLFWmonitor*,const(GLFWgammaramp)*);
    void glfwDefaultWindowHints();
    void glfwWindowHint(int,int);
    GLFWwindow* glfwCreateWindow(int,int,const(char)*,GLFWmonitor*,GLFWwindow*);
    void glfwDestroyWindow(GLFWwindow*);
    int glfwWindowShouldClose(GLFWwindow*);
    void glfwSetWindowShouldClose(GLFWwindow*,int);
    void glfwSetWindowTitle(GLFWwindow*,const(char)*);
    void glfwSetWindowIcon(GLFWwindow*,int,const(GLFWimage)*);
    void glfwGetWindowPos(GLFWwindow*,int*,int*);
    void glfwSetWindowPos(GLFWwindow*,int,int);
    void glfwGetWindowSize(GLFWwindow*,int*,int*);
    void glfwSetWindowSizeLimits(GLFWwindow*,int,int,int,int);
    void glfwSetWindowAspectRatio(GLFWwindow*,int,int);
    void glfwSetWindowSize(GLFWwindow*,int,int);
    void glfwGetFramebufferSize(GLFWwindow*,int*,int*);
    void glfwGetWindowFrameSize(GLFWwindow*,int*,int*,int*,int*);
    void glfwIconifyWindow(GLFWwindow*);
    void glfwRestoreWindow(GLFWwindow*);
    void glfwMaximizeWindow(GLFWwindow*);
    void glfwShowWindow(GLFWwindow*);
    void glfwHideWindow(GLFWwindow*);
    void glfwFocusWindow(GLFWwindow*);
    GLFWmonitor* glfwGetWindowMonitor(GLFWwindow*);
    void glfwSetWindowMonitor(GLFWwindow*,GLFWmonitor*,int,int,int,int,int);
    int glfwGetWindowAttrib(GLFWwindow*,int);
    void glfwSetWindowUserPointer(GLFWwindow*,void*);
    void* glfwGetWindowUserPointer(GLFWwindow*);
    GLFWwindowposfun glfwSetWindowPosCallback(GLFWwindow*,GLFWwindowposfun);
    GLFWwindowsizefun glfwSetWindowSizeCallback(GLFWwindow*,GLFWwindowsizefun);
    GLFWwindowclosefun glfwSetWindowCloseCallback(GLFWwindow*,GLFWwindowclosefun);
    GLFWwindowrefreshfun glfwSetWindowRefreshCallback(GLFWwindow*,GLFWwindowrefreshfun);
    GLFWwindowfocusfun glfwSetWindowFocusCallback(GLFWwindow*,GLFWwindowfocusfun);
    GLFWwindowiconifyfun glfwSetWindowIconifyCallback(GLFWwindow*,GLFWwindowiconifyfun);
    GLFWframebuffersizefun glfwSetFramebufferSizeCallback(GLFWwindow*,GLFWframebuffersizefun);
    void glfwPollEvents();
    void glfwWaitEvents();
    void glfwWaitEventsTimeout(double);
    void glfwPostEmptyEvent();
    int glfwGetInputMode(GLFWwindow*,int);
    void glfwSetInputMode(GLFWwindow*,int,int);
    const(char)* glfwGetKeyName(int,int);
    int glfwGetKey(GLFWwindow*,int);
    int glfwGetMouseButton(GLFWwindow*,int);
    void glfwGetCursorPos(GLFWwindow*,double*,double*);
    void glfwSetCursorPos(GLFWwindow*,double,double);
    GLFWcursor* glfwCreateCursor(const(GLFWimage)*,int,int);
    GLFWcursor* glfwCreateStandardCursor(int);
    void glfwDestroyCursor(GLFWcursor*);
    void glfwSetCursor(GLFWwindow*,GLFWcursor*);
    GLFWkeyfun glfwSetKeyCallback(GLFWwindow*,GLFWkeyfun);
    GLFWcharfun glfwSetCharCallback(GLFWwindow*,GLFWcharfun);
    GLFWcharmodsfun glfwSetCharModsCallback(GLFWwindow*,GLFWcharmodsfun);
    GLFWmousebuttonfun glfwSetMouseButtonCallback(GLFWwindow*,GLFWmousebuttonfun);
    GLFWcursorposfun glfwSetCursorPosCallback(GLFWwindow*,GLFWcursorposfun);
    GLFWcursorenterfun glfwSetCursorEnterCallback(GLFWwindow*,GLFWcursorenterfun);
    GLFWscrollfun glfwSetScrollCallback(GLFWwindow*,GLFWscrollfun);
    GLFWdropfun glfwSetDropCallback(GLFWwindow*,GLFWdropfun);
    int glfwJoystickPresent(int);
    float* glfwGetJoystickAxes(int,int*);
    ubyte* glfwGetJoystickButtons(int,int*);
    const(char)* glfwGetJoystickName(int);
    GLFWjoystickfun glfwSetJoystickCallback(GLFWjoystickfun);
    void glfwSetClipboardString(GLFWwindow*,const(char)*);
    const(char)* glfwGetClipboardString(GLFWwindow*);
    double glfwGetTime();
    void glfwSetTime(double);
    long glfwGetTimerValue();
    long glfwGetTimerFrequency();
    void glfwMakeContextCurrent(GLFWwindow*);
    GLFWwindow* glfwGetCurrentContext();
    void glfwSwapBuffers(GLFWwindow*);
    void glfwSwapInterval(int);
    int glfwExtensionSupported(const(char)*);
    GLFWglproc glfwGetProcAddress(const(char)*);
    int glfwVulkanSupported();
}

// Mixins to allow linking with Vulkan & OS native functions using the
// types declared in whatever Vulkan or OS binding an app is using.
mixin template DerelictGLFW3_VulkanBind() {
    extern(C) @nogc nothrow {
        const(char)** glfwGetRequiredInstanceExtensions(uint*);
        GLFWvkproc glfwGetInstanceProcAddress(VkInstance,const(char)*);
        int glfwGetPhysicalDevicePresentationSupport(VkInstance,VkPhysicalDevice,uint);
        VkResult glfwCreateWindowSurface(VkInstance,GLFWwindow*,const(VkAllocationCallbacks)*,VkSurfaceKHR*);
    }
}

mixin template DerelictGLFW3_EGLBind() {
    extern(C) @nogc nothrow {
        EGLDisplay glfwGetEGLDisplay();
        EGLContext glfwGetEGLContext(GLFWwindow*);
        EGLSurface glfwGetEGLSurface(GLFWwindow*);
    }
}

// The static binding shouldn't depend on DerelictUtil, so use
// version identifiers here rather than static if with Derelict_OS_*.
version(OSX) {
    mixin template DerelictGLFW3_MacBind() {
        extern(C) @nogc nothrow {
            CGDirectDisplayID glfwGetCocoaMonitor(GLFWmonitor*);
            id glfwGetCocoaWindow(GLFWwindow*);
            id glfwGetNSGLContext(GLFWwindow*);
        }
    }
    alias DerelictGLFW3_NativeBind = DerelictGLFW3_MacBind;
}
else version(Windows) {
    mixin template DerelictGLFW3_WindowsBind() {
        extern(C) @nogc nothrow {
            const(char)* glfwGetWin32Adapter(GLFWmonitor*);
            const(char)* glfwGetWin32Monitor(GLFWmonitor*);
            HWND glfwGetWin32Window(GLFWwindow*);
            HGLRC glfwGetWGLContext(GLFWwindow*);
        }
    }
    alias DerelictGLFW3_NativeBind = DerelictGLFW3_WindowsBind;
}
else version(Posix) {
    mixin template DerelictGLFW3_X11Bind() {
        extern(C) @nogc nothrow {
            Display* glfwGetX11Display();
            RRCrtc glfwGetX11Adapter(GLFWmonitor*);
            RROutput glfwGetX11Monitor(GLFWmonitor*);
            Window glfwGetX11Window(GLFWwindow*);
            GLXContext glfwGetGLXContext(GLFWwindow*);
            GLXwindow glfwGetGLXWindow(GLFWwindow*);
        }
    }
    alias DerelictGLFW3_NativeBind = DerelictGLFW3_X11Bind;

    mixin template DerelictGLFW3_WaylandBind() {
        extern(C) @nogc nothrow {
            wl_display* glfwGetWaylandDisplay();
            wl_output* glfwGetWaylandMonitor(GLFWmonitor*);
            wl_surface* glfwGetWaylandWindow(GLFWwindow*);
        }
    }

    mixin template DerelictGLFW3_MirBind() {
        extern(C) @nogc nothrow {
            MirConnection* glfwGetMirDisplay();
            int glfwGetMirMonitor(GLFWmonitor*);
            MirSurface* glfwGetMirWindow(GLFWwindow*);
        }
    }
}

