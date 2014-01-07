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
    void add_to_state(lua_State* L);
}
#endif
