//
//  MyCCGLDrawing.h
//  CCGLBasic example
//
//  Created by Matthieu Savary on 03/03/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGL project >> http://cocoacid.org/ios/
//  License & disclaimer >> see license.txt file included in the distribution package
//

#ifndef MyCCGLDrawing__h
#define MyCCGLDrawing__h

#include "CCGLView.h"

#include "cinder/Camera.h"

#include "LuaManager.h"
#include "lua.hpp"

@interface MyCCGLDrawing : CCGLView
{
	LuaManager luaMan;
    lua_State* L;
    //std::thread lua_prompt_thread;
    //bool exiting;
}

/**
 *  Cocoa UI methods
 */

//- (void) setCubeSize: (int) bits;

//void lua_prompt();
//void exit();

@end

#endif