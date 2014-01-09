//
//  DrawingView.h
//  CCGLBasic example
//
//  Created by Matthieu Savary on 03/03/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGL project >> http://cocoacid.org/ios/
//  License & disclaimer >> see license.txt file included in the distribution package
//

#ifndef DrawingView__h
#define DrawingView__h

#include "CCGLView.h"

#include "cinder/Camera.h"

#include "LuaManager.h"
#include "lua.hpp"

@interface DrawingView : CCGLView
{
	LuaManager luaMan;
    lua_State* L;
    //std::thread lua_prompt_thread;
    //bool exiting;
}

-(void)close_state;

-(int) getWidth;
-(int) getHeight;

/**
 *  Cocoa UI methods
 */

//- (void) setCubeSize: (int) bits;

//void lua_prompt();
//void exit();

@end

#endif