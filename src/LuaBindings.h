//
//  LuaBindings.h
//  MetatronsGroove
//
//  Created by Stewart Bracken on 12/19/13.
//
//

#ifndef MetatronsGroove_LuaBindings_h
#define MetatronsGroove_LuaBindings_h

#include "lua.hpp"

namespace luabindings{
//instanced for each Drawing
class LuaWindow{
private:
    int _width = 200, _height = 200;
public:
    LuaWindow(int _w, int _h):_width(_w),_height(_h){}
    int width()const{return _width;}
    int height()const{return _height;}
    void size(int _w, int _h){
        _width = _w;
        _height = _h;
    }};


    void add_to_state(lua_State* L);
}
#endif
