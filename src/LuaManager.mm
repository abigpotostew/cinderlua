//
//  LuaManager.cpp
//  MetatronsGroove
//
//  Created by Stewart Bracken on 9/29/13.
//
//

#include "LuaManager.h"

//#include <stdio.h>

//#include "lua.hpp"
//#ifndef LUABRIDGE_LUABRIDGE_HEADER
//#include "LuaBridge.h"
//#endif

#include <iostream>

//using namespace luabridge;

static lua_State* globalL = 0;

LuaManager::LuaManager(){
    this->L = luaL_newstate();
    luaL_openlibs(L);
}

LuaManager::~LuaManager(){
    if(this->L)
        lua_close(this->L);
}

lua_State* LuaManager::loadLuaFile(const char* luaPath){
    
    int status = luaL_loadfile(L,luaPath);
    if ( status != 0 ){
        // compile-time error
        std::cerr << lua_tostring(L, -1) << std::endl;
        lua_close(L);
        return NULL;
    }
    
    return L;
}

int LuaManager::report(int status) {
    if (status && !lua_isnil(L, -1)) {
        const char *msg = lua_tostring(L, -1);
        if (msg == NULL) msg = "(error object is not a string)";
        std::cout << msg << std::endl;
        lua_pop(L, 1);
    }
    return status;
}

lua_State* LuaManager::run(){
    //run the entire script once.
    int status = lua_pcall(L, 0,0,0);
    if ( status != 0 ){
        //runtime error
        std::cerr << lua_tostring(L,-1)<<std::endl;
        lua_close(L);
        return NULL;
    }
    return L;
}


// traceback function, adapted from lua.c
// when a runtime error occurs, this will append the call stack to the error message
//
static int traceback (lua_State* L_state)
{
    // look up Lua's 'debug.traceback' function
    lua_getglobal(L_state, "debug");
    if (!lua_istable(L_state, -1))
    {
        lua_pop(L_state, 1);
        return 1;
    }
    lua_getfield(L_state, -1, "traceback");
    if (!lua_isfunction(L_state, -1))
    {
        lua_pop(L_state, 2);
        return 1;
    }
    lua_pushvalue(L_state, 1);  // pass error message
    lua_pushinteger(L_state, 2); // skip this function and traceback
    lua_call(L_state, 2, 1);  // call debug.traceback
    return LUA_ERRRUN;
}

static int prompt_traceback(lua_State* L){
    const char *msg = lua_tostring(L, 1);
    if (msg)
        luaL_traceback(L, L, msg, 1);
    else if (!lua_isnoneornil(L, 1)) {  /* is there an error object? */
        if (!luaL_callmeta(L, 1, "__tostring"))  /* try its 'tostring' metamethod */
            lua_pushliteral(L, "(no error message)");
    }
    return 1;
}

int LuaManager::addTraceback (lua_State* lua_s)
{
    lua_pushcfunction (lua_s, traceback);
    return luaL_ref (lua_s, LUA_REGISTRYINDEX);
}

static void lstop (lua_State *L, lua_Debug *ar) {
    (void)ar;  /* unused arg. */
    lua_sethook(L, NULL, 0, 0);
    luaL_error(L, "interrupted!");
}

static void laction (int i) {
    signal(i, SIG_DFL); /* if another SIGINT happens before lstop,
                         terminate process (default action) */
    lua_sethook(globalL, lstop, LUA_MASKCALL | LUA_MASKRET | LUA_MASKCOUNT, 1);
}

int LuaManager::docall(int narg, int nres){
    int status;
    int base = lua_gettop(L) - narg;  /* function index */
    lua_pushcfunction(L, prompt_traceback);  /* push traceback function */
    lua_insert(L, base);  /* put it under chunk and args */
    globalL = L;  /* to be available to 'laction' */
    signal(SIGINT, &laction);
    status = lua_pcall(L, narg, nres, base);
    signal(SIGINT, SIG_DFL);
    lua_remove(L, base);  /* remove traceback function */
    /* force a complete garbage collection in case of errors */
    //if (status != 0) lua_gc(L, LUA_GCCOLLECT, 0);
    return status;
}

int LuaManager::dostring(const std::string& s){
    //std::cout<<"Attempting to run: "<<s.c_str()<<std::endl;
    int status = luaL_loadbuffer(L, s.c_str(), s.length(), ">");
    if (status == LUA_OK) status = docall(0, 0);
    return report(status);
}
