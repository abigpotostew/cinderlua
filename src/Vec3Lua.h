//
//  VecLua.h
//  MetatronsGroove
//
//  Created by Stewart Bracken on 10/1/13.
//
//

#ifndef MetatronsGroove_Vec3Lua_h
#define MetatronsGroove_Vec3Lua_h

#include "lua.hpp"
#include "LuaBridge.h"
#include "RefCountedObject.h"

#import "CCGLView.h"

#define PTR_RETURN Vec3Lua*

struct Vec3Lua : public RefCountedObjectType<int>{
public:
    float x,y,z;
    
    typedef RefCountedObjectPtr<Vec3Lua> Ptr;
    
    Vec3Lua():x(),y(),z() { }
    
    Vec3Lua(float _x, float _y, float _z):x(_x),y(_y),z(_z) { }
    
    Vec3Lua(const Vec3f& v):x(v.x),y(v.y),z(v.z) {}
    Vec3Lua(const Vec2f& v):x(v.x),y(v.y),z(0.f) {}
    
    /*Vec3Lua<T>& operator=(const Vec3Lua<T>& other){
        *this = other;
    }*/
    
    operator Vec2f() const{
        return this->xy();
    }
    
    void setPropX(float _x){x=_x;}
    float getPropX() const{return x;}
    void setPropY(float _y){y=_y;}
    float getPropY() const{return y;}
    void setPropZ(float _z){z=_z;}
    float getPropZ() const{return z;}
    
    /* Operators */
    PTR_RETURN addLua (Vec3Lua const& other)const;
    PTR_RETURN subLua (Vec3Lua const& other)const;
    PTR_RETURN negate()const;
    PTR_RETURN mult (float& s) const;
    PTR_RETURN div (float& d) const;
    
    /* Vector Functions */
    float dotLua(Vec3Lua const& other) const;
    float lengthLua() const;
    PTR_RETURN normalizedLua() const;
    PTR_RETURN copy() const;
    
    /* Used for cinder draw functions */
    Vec3f xyz() const;
    Vec2f xy() const;
    
    int xy(lua_State* L); //use in lua
};

typedef Vec3Lua Vec3fLua;


#endif
