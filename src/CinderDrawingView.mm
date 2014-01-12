//
//  DrawingView.mm
//  An NSView subclass that recives a lua script and runs the main loop.
//  This is the Cocoa version of a Cinder app.
//
//  Created by Matthieu Savary on 03/03/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGL project >> http://cocoacid.org/ios/
//  License & disclaimer >> see license.txt file included in the distribution package
//


#import "CinderDrawingView.h"

#import "NSWindow+SBAdditions.h"

#include "LuaBridge.h"
#include "LuaBindings.h"

#include "Resources.h"

@implementation CinderDrawingView

/**
 *  The setup method
 */

- (void) setup
{
	[super setup];
    
    if( luaMan != NULL )
        delete luaMan;
    
    luaMan = new LuaManager();
	
    // Recieve lua text file
	string lua_path = luaMainPath;//[super getResourcePath:luaMainPath];//RES_MAIN_LUA
    
    L = luaMan->loadLuaFile(lua_path.c_str());
    if (L==NULL) return;
    
    // Add all my class and namespace bindings.
    luabindings::add_to_state(L);
    
    //Each lua state keeps track of it's window
    luabridge::push( L, luabindings::LuaWindow( 300, 300 ) ); //push a new instance of the window class
    lua_setglobal( L, "window" );
    //TODO: Make this window table immutable in lua by changing it's metamethods
    
    luabridge::push(L, luabindings::LuaApp(consoleOut));
    lua_setglobal( L, "__CLAPP"); //hidden instance to this view, for printing.
    
    luaMan->dostring("print = function(message) __CLAPP:printToConsole(message) end");
    
    // Execute lua files in order
    luaMan->run();
    
    //Call global setup function initialized by user.
    luabridge::LuaRef setupLua = luabridge::getGlobal(L,"setup");
    try{
        setupLua();
    }catch(luabridge::LuaException const& e){
        //TODO: skip this message
        //console()<<"Error running setup(). It's either undefined or broken."<<endl;
    }
    
    luabridge::LuaRef window = luabridge::getGlobal(L, "window");
    int newWidth = window["width"];
    int newHeight = window["height"];
    
    // Resize window to user specified dimensions from lua.
    [[self.superview window] sb_resizeToSize:NSMakeSize(newWidth, newHeight)];
    
    // Resize the drawing view
    NSRect f = [self frame];
    f.size.width = newWidth;
    f.size.height = newHeight;
    f.origin.x = 0; // bottom
    f.origin.y = 0; // left
    [self setFrame: f];
    
    // Prevent window resizing.
    [self.window setMinSize:[self.window frame].size];
    [self.window setMaxSize:[self.window frame].size];
    
    //clear black to avoid artifacts.
    gl::clear();
    
    
    appSetupCalled = true;
}



/**
 *  The draw loop method
 */

- (void) draw
{
    if(!appSetupCalled || L==NULL)return;
	luabridge::LuaRef drawLua = luabridge::getGlobal(L,"draw");
    try{
        drawLua();
    }catch(luabridge::LuaException const& e){
        luabridge::LuaRef print = luabridge::getGlobal(L,"print");
        //TODO: user may override print, and this could bug out, careful!
        print(e.what());
        //console()<<e.what()<<std::endl;
        //TODO: stop looping if program reaches here.
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

-(void)clearLuaState
{
    if(luaMan != NULL){
        delete luaMan;
        luaMan = NULL;
        //luaMan->close_state();
    }
    appSetupCalled = false;
}

-(void) callSetupNewLuaState
{
    [self setup];
}


-(void) setLuaMainPath:(const char*) path
{
    if(path == nil){
        luaMainPath = RES_EMPTY_MAIN_LUA;
    }else{
        luaMainPath = string( path );
    }
}


-(void) setConsoleOut:(NSTextView*)console{
    consoleOut = console;
}

@end
