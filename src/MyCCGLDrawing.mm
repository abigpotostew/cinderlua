//
//  MyCCGLDrawing.mm
//  CCGLBasic example
//
//  Created by Matthieu Savary on 03/03/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGL project >> http://cocoacid.org/ios/
//  License & disclaimer >> see license.txt file included in the distribution package
//


#import "MyCCGLDrawing.h"

#include "LuaBridge.h"
#include "LuaBindings.h"

#include "Resources.h"

@implementation MyCCGLDrawing

/**
 *  The setup method
 */

- (void) setup
{
	[super setup];
	
    //recieve lua text file
	string lua_path = [super getResourcePath:RES_MAIN_LUA];
    L = luaMan.loadLuaFile(lua_path.c_str());
    
    luabindings::add_to_state(L);
    
    // Execute lua files in order
    luaMan.run();
    
    
    luabridge::LuaRef setup = luabridge::getGlobal(L,"setup");
    try{
        setup();
        //console()<<"[C++] Called Lua setup()."<<endl;
    }catch(luabridge::LuaException const& e){
        //console()<<"[C++] No Lua setup() function defined, skipping." <<endl;
    }
    
    //lua_prompt_thread = std::thread(&MetatronsGrooveApp::lua_prompt,this);
    
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

@end
