//
//  LuaBindings.cpp
//  MetatronsGroove
//
//  Created by Stewart Bracken on 12/19/13.
//
//

#include "LuaBindings.h"

#include "cinder/gl/gl.h"
#include "cinder/Color.h"
#include "cinder/Vector.h"


#include "LuaBridge.h"
//#include "Audio.h"
//#include "Vec3Lua.h"

//General draw functions
namespace DrawLua{
    static void clear(float r=0.f, float g=0.f, float b=0.f, float a=1.f){
        cinder::gl::clear(cinder::ColorA(r,g,b,a));
    }
    static void color(float r=0.f, float g=0.f, float b=0.f, float a=1.f){
        cinder::gl::color(cinder::ColorA(r,g,b,a));
    }
    static void pushMatrices(){
        cinder::gl::pushMatrices();
    }
    static void popMatrices(){
        cinder::gl::popMatrices();
    }
    static int gl_points = GL_POINTS;
    static int gl_lines = GL_LINES;
    static int gl_line_loop = GL_LINE_LOOP;
    static int gl_line_strip = GL_LINE_STRIP;
    static int gl_triangles = GL_TRIANGLES;
    static int gl_triangle_strip = GL_TRIANGLE_STRIP;
    static int gl_triangle_fan = GL_TRIANGLE_FAN;
    static int gl_quads = GL_QUADS;
    static int gl_quad_strip = GL_QUAD_STRIP;
    static int gl_polygon = GL_POLYGON;
    
    static void begin(int mode){
        glBegin(mode);
    }
    static void end(){
        glEnd();
    }
};

namespace Draw2DLua{
    static void rotate(float degrees){
        cinder::gl::rotate(degrees);
    }
    static void translate(float x, float y){
        cinder::gl::translate(cinder::Vec2f(x,y));
    }
    static void strokedCircle(float x,float y, float radius){
        cinder::gl::drawStrokedCircle(cinder::Vec2f(x,y), radius);
    }
    static void solidCircle(float x,float y, float radius){
        cinder::gl::drawSolidCircle(cinder::Vec2f(x,y), radius);
    }
    static void vertex2(float x, float y){
        cinder::gl::vertex(x, y);
    }
    static void line(float x1, float y1, float x2, float y2){
        cinder::gl::drawLine(cinder::Vec2f(x1,y1), cinder::Vec2f(x2,y2));
    }
};

namespace Draw3DLua{
    static void vertex3(float x, float y, float z){
        cinder::gl::vertex(x, y, z);
    }
    static void drawSphere(float x,float y,float z,float radius){
        cinder::gl::drawSphere(cinder::Vec3f(x,y,z), radius);
    }
};

namespace CinderAppLua{
    static int width = 200,
    height = 200;
    static double startTime;
    static void size(int _width, int _height){
        width = _width;
        height = _height;
        //::app::setWindowSize(width, height);
    }
    static double getElapsedSeconds(){
        return ::CFAbsoluteTimeGetCurrent() - startTime;
    }
    static void console_print(std::string& m){
        //redirect our lua print to app's console here.
    }
}



//class b{
//public:
//    void func();
//};

void luabindings::add_to_state(lua_State* L){
    
    CinderAppLua::startTime = ::CFAbsoluteTimeGetCurrent();
    
    luabridge::getGlobalNamespace(L)
    .beginClass<LuaWindow>("window")
        .addConstructor<void(*)(int, int)>()
        .addProperty("width", &LuaWindow::width)
        .addProperty("height", &LuaWindow::height)
        .addFunction("size", &LuaWindow::size)
    .endClass();
    
    luabridge::getGlobalNamespace(L)
    .beginClass<LuaApp>("__CLApp")
    .addConstructor<void(*)(void)>()
        .addFunction("printToConsole", &LuaApp::print_to_console_pipe)
    .endClass();
    
    //LuaRef v2 = getGlobal (L, "print")
    
    luabridge::getGlobalNamespace(L)
    .beginNamespace("time")
    .addFunction("seconds", &CinderAppLua::getElapsedSeconds)
    //.addFunction("frames", &ci::app::getElapsedFrames)
    .endNamespace()
    ;
    /*
    // Vector interface
    luabridge::getGlobalNamespace (L)
    .beginClass<Vec3fLua>("Vec3")
    .addConstructor<void(*)(void)> ()
    .addConstructor<void(*)(float,float,float)> ()
    .addProperty ("x", &Vec3fLua::getPropX, &Vec3fLua::setPropX)
    .addProperty ("y", &Vec3fLua::getPropY, &Vec3fLua::setPropY)
    .addProperty ("z", &Vec3fLua::getPropZ, &Vec3fLua::setPropZ)
    .addFunction ("__add", &Vec3fLua::addLua)
    .addFunction("__sub", &Vec3fLua::subLua)
    .addFunction("__unm", &Vec3fLua::negate)
    //TODO MUTL & DIV operator
    .addFunction("dot", &Vec3fLua::dotLua)
    .addFunction("length", &Vec3fLua::lengthLua)
    .addFunction("normalized", &Vec3fLua::normalizedLua)
    .addFunction("copy",&Vec3fLua::copy)
    
    .addCFunction("xy", &Vec3fLua::xy)
    .endClass ()
    ;
    */
    
    // Draw function interface
    luabridge::getGlobalNamespace(L)
    .beginNamespace("gl")
    //2D
    .addFunction("solidCircle",&Draw2DLua::solidCircle)
    .addFunction("strokedCircle",&Draw2DLua::strokedCircle)
    .addFunction("line", &Draw2DLua::line)
    
    //3D
    .addFunction("sphere", &Draw3DLua::drawSphere)
    
    .addFunction("clear", &DrawLua::clear)
    .addFunction("color", &DrawLua::color)
    
    .addFunction("translate",  &Draw2DLua::translate)
    .addFunction("rotate", &Draw2DLua::rotate) //degrees
    .addFunction("pushMatrices", &DrawLua::pushMatrices)
    .addFunction("popMatrices", &DrawLua::popMatrices)
    
    .addFunction("shapeBegin", &DrawLua::begin)
    .addFunction("shapeEnd", &DrawLua::end)
    .addFunction("vertex2", &Draw2DLua::vertex2)
    .addFunction("vertex3", &Draw3DLua::vertex3)
    //GL Draw modes:
    .addVariable("POINTS", &DrawLua::gl_points)
    .addVariable("LINES", &DrawLua::gl_lines)
    .addVariable("LINE_LOOP", &DrawLua::gl_line_loop)
    .addVariable("LINE_STRIP", &DrawLua::gl_line_strip)
    .addVariable("TRIANGLES", &DrawLua::gl_triangles)
    .addVariable("TRIANGLE_FAN", &DrawLua::gl_triangle_fan)
    .addVariable("TRIANGLE_STRIP", &DrawLua::gl_triangle_strip)
    .addVariable("QUADS", &DrawLua::gl_quads)
    .addVariable("QUAD_STRIP", &DrawLua::gl_quad_strip)
    .addVariable("POLYGON", &DrawLua::gl_polygon)
    .endNamespace();
    
    /* AUDIO class interface */
    /*luabridge::getGlobalNamespace(L)
    .beginClass<Audio>("Audio")
        .addConstructor<void(*)(void)>()
        .addFunction("loadTrack",&Audio::loadTrackLua)
        //.addProperty("getLow", &Audio::getAvgLowFft)
        //.addProperty("getMid", &Audio::getAvgMidFft)
        //.addProperty("getHigh", &Audio::getAvgHighFft)
        .addFunction("getBandCount", &Audio::getBandCount)
        .addCFunction("getSpectrum", &Audio::getSpectrumLua)
        .addFunction("setVolume", &Audio::setVolume)
        .addFunction("setLoop", &Audio::setLoop)
        .addFunction("update", &Audio::update) //update buffer & fft.
        .addFunction("getSmoothing", &Audio::getSmoothing)
        .addFunction("setSmoothing", &Audio::setSmoothing)
        .addFunction("useDecibels", &Audio::set_dB)
    .endClass()
    ;*/
}