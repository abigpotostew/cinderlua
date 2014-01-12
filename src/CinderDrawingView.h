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

@interface CinderDrawingView : CCGLView
{
	LuaManager* luaMan;
    lua_State* L;
    
    string luaMainPath;
    NSTextView* consoleOut;
}

-(void)close_state;

-(int) getWidth;
-(int) getHeight;

-(void) clearLuaState;

//call setup with the next event loop.
-(void) callSetupNewLuaState;

-(void) setLuaMainPath:(const char*)path;

-(void) setConsoleOut:(NSTextView*)console;

@end

#endif