//
//  DrawingView.mm
//  CCGLBasic example
//
//  Created by Matthieu Savary on 03/03/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGL project >> http://cocoacid.org/ios/
//  License & disclaimer >> see license.txt file included in the distribution package
//


#import "DrawingView.h"

#include "LuaBridge.h"
#include "LuaBindings.h"

#include "Resources.h"

@implementation DrawingView

/**
 *  The setup method
 */

- (void) setup
{
	[super setup];
	
    // Recieve lua text file
	string lua_path = [super getResourcePath:RES_MAIN_LUA];
    L = luaMan.loadLuaFile(lua_path.c_str());
    
    // Add all my class and namespace bindings.
    luabindings::add_to_state(L);
    
    //Each lua state keeps track of it's window
    luabridge::push( L, luabindings::LuaWindow( 300, 300 ) );
    lua_setglobal( L, "window" );
    //TODO: Make this window table immutable in lua by changing it's metamethods
    
    // Execute lua files in order
    luaMan.run();
    
    luabridge::LuaRef setup = luabridge::getGlobal(L,"setup");
    try{
        setup();
    }catch(luabridge::LuaException const& e){
        //console()<<"[C++] No Lua setup() function defined, skipping." <<endl;
    }
    
    //lua_prompt_thread = std::thread(&MetatronsGrooveApp::lua_prompt,this);
    
    luabridge::LuaRef window = luabridge::getGlobal(L, "window");
    int w = [self getWidth];
    
    //clear black to avoid artifacts.
    gl::clear();
}



/**
 *  The draw loop method
 */

- (void) draw
{
	luabridge::LuaRef drawLua = luabridge::getGlobal(L,"draw");
    try{
        drawLua();
    }catch(luabridge::LuaException const& e){
        console()<<e.what()<<std::endl;
        //close lua state. report error. wait for user to do something
        exit();
    }
}


-(int) getWidth
{
    luabridge::LuaRef window = luabridge::getGlobal(L, "window");
    return window["width"];
}
-(int) getHeight;
{
    luabridge::LuaRef window = luabridge::getGlobal(L, "window");
    return window["height"];
}

/**
 *  Cocoa UI methods
 */

/*- (void) setCubeSize: (int) size
{
	//mCubeSize = size;
	//console() << size << endl;
}*/



/**
 *  Superclass events
 */

- (void)reshape
{
	[super reshape];
	
}

- (void)mouseDown:(NSEvent*)theEvent
{
	[super mouseDown:(NSEvent *)theEvent];
	
}

- (void)mouseDragged:(NSEvent *)theEvent
{
	[super mouseDragged:(NSEvent *)theEvent];
	
}

void exit(){
    //exiting = true;
    //lua_prompt_thread.join();
    //quit();
}

-(void)close_state
{
    //lua_close(L);
    //NSLog(@"closing state");
}

-(void) dealloc
{
    //[self close_state];
    [super dealloc];
}



@end
