//
//  Vec3Lua.c
//  MetatronsGroove
//
//  Created by Stewart Bracken on 10/1/13.
//
//

#include "Vec3Lua.h"

//#define PTR_RETURN Vec3Lua::Ptr
#define PTR_RETURN Vec3Lua*

PTR_RETURN Vec3Lua::addLua (Vec3Lua const& other) const{
    Vec3Lua * out = new Vec3Lua  (this->x + other.x,this->y + other.y,this->z + other.z);
    return (out);
}


PTR_RETURN Vec3Lua::subLua (Vec3Lua const& other) const{
    Vec3Lua * out = new Vec3Lua (this->x - other.x,this->y - other.y,this->z - other.z);
    return (out);
}


PTR_RETURN Vec3Lua::negate() const{
    Vec3Lua * out = new Vec3Lua (-this->x,-this->y,-this->z);
    return (out);
}



PTR_RETURN Vec3Lua::mult(float& s) const{
    Vec3Lua * out = new Vec3Lua (this->x * s,this->y * s,this->z * s);
    return (out);
}


PTR_RETURN Vec3Lua::div (float& d) const{
    return new Vec3Lua(x/d,y/d,z/d);
}



// Vector Functions

float Vec3Lua::dotLua(Vec3Lua const& other) const{
    return x*other.x + y*other.y + z*other.z;
}


float Vec3Lua::lengthLua() const{
    return sqrt(this->dotLua(*this));
}


PTR_RETURN Vec3Lua::normalizedLua() const{
    float l = lengthLua();
    Vec3Lua * out = new Vec3Lua (this->x/l,this->y/l,this->z/l);
    return (out);
}


PTR_RETURN Vec3Lua::copy() const{
    Vec3Lua * out = new Vec3Lua (*this);
    return (out);
}


cinder::Vec3f Vec3Lua::xyz() const{
    return Vec3f(x,y,z);
}

cinder::Vec2f Vec3Lua::xy() const{
    return Vec3f(x,y,z).xy();
}

int Vec3Lua::xy(lua_State* L){
    lua_pushnumber(L, x);
    lua_pushnumber(L, y);
    return 2;
}

/*
template<class T>
Vec3Lua<T>* Vec3Lua<T>::addLua (Vec3Lua<T> const& other) const{
    Vec3Lua<T> * out = new Vec3Lua<T>  (this->x + other.x,this->y + other.y,this->z + other.z);
    return (out);
}

template<class T>
Vec3Lua<T>* Vec3Lua<T>::subLua (Vec3Lua<T> const& other) const{
    Vec3Lua<T> * out = new Vec3Lua<T> (this->x - other.x,this->y - other.y,this->z - other.z);
    return (out);
}

template<class T>
Vec3Lua<T>* Vec3Lua<T>::negate() const{
    Vec3Lua<T> * out = new Vec3Lua<T> (-this->x,-this->y,-this->z);
    return (out);
}


template<class T>
Vec3Lua<T>* Vec3Lua<T>::mult(float& s) const{
    Vec3Lua<T> * out = new Vec3Lua<T> (this->x * s,this->y * s,this->z * s);
    return (out);
}

template<class T>
 Vec3Lua<T>* Vec3Lua<T>::div (float& d) const{
    return new Vec3Lua<T> (*this / d);
}



// Vector Functions
template<class T>
T Vec3Lua<T>::dotLua(Vec3Lua<T> const& other) const{
    return x*other.x + y*other.y + z*other.z;
}

template<class T>
T Vec3Lua<T>::lengthLua() const{
    return sqrt(this->dotLua(*this));
}

template<class T>
Vec3Lua<T>* Vec3Lua<T>::normalizedLua() const{
    T l = lengthLua();
    Vec3Lua<T> * out = new Vec3Lua<T> (this->x/l,this->y/l,this->z/l);
    return (out);
}
 
template<class T>
Vec3Lua<T>* Vec3Lua<T>::copy() const{
    Vec3Lua<T> * out = new Vec3Lua<T> (*this);
    return (out);
}

template<class T>
cinder::Vec3<T> Vec3Lua<T>::xyz() const{
    return Vec3<T>(x,y,z);
}

template<class T>
cinder::Vec2<T> Vec3Lua<T>::xy() const{
    return Vec3<T>(x,y,z).xy();
}


template<>
cinder::Vec2f Vec3Lua<float>::xy() const{
    return Vec3f(x,y,z).xy();
}
*/