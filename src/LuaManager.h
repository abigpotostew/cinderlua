//
//  LuaManager.h
//  MetatronsGroove
//
//  Created by Stewart Bracken on 9/29/13.
//
//

#ifndef __MetatronsGroove__LuaManager__
#define __MetatronsGroove__LuaManager__

#include "lua.hpp"
#include <string>
//#import "CCGLView.h"

class LuaManager{
    lua_State* L;
public:
    LuaManager();
    ~LuaManager();
    lua_State* loadLuaFile(const char* luaPath);
    int addTraceback(lua_State*);
    lua_State* run();
    void close_state();

    
    int dostring(const std::string& s);
    int docall(int narg, int clear);
    
    int report(int status);
    
private:
    int errorFunctionRef;
};

#endif /* defined(__MetatronsGroove__LuaManager__) */
