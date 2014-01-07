#include "cinder/app/AppNative.h"
#include "cinder/gl/gl.h"
#include <iostream>
#include <sstream>

#include <stdio.h> //getch(), kbhit()

//#include "Resources.h"

//Library headers
#include "lua.hpp"
#include "LuaBridge.h"

//My headers
#include "LuaManager.h"
#include "LuaBindings.h"

using namespace ci;
using namespace ci::app;

class MetatronsGrooveApp : public AppNative {
  public:
    void prepareSettings(Settings* settings);
	void setup();
	void mouseDown( MouseEvent event );	
	void update();
    void keyDown(KeyEvent);
	void draw();
    void runLua();
    void fileDrop(FileDropEvent);
    LuaManager luaMan;
    lua_State* L;
    void exit();
    std::thread lua_prompt_thread;
    void lua_prompt();
    bool exiting = false;
};


void MetatronsGrooveApp::prepareSettings( Settings *settings )
{
	settings->setWindowSize( 800, 600 );
	settings->setFrameRate( 60.0f );
}

void MetatronsGrooveApp::runLua(){
    //LuaManager lm;
    fs::path lua_path = getResourcePath(RES_MAIN_LUA);
    /*
     //Test open dialogue with extention restrictions
    vector<std::string> exts;
    exts.push_back("mp3");
    exts.push_back("wav");
    exts.push_back("aif");
    exts.push_back("aiff");
    fs::path test_path = getOpenFilePath("",exts);
    */
    
    L = luaMan.loadLuaFile(lua_path.c_str());

    //Add to state:
    luabindings::add_to_state(L);
    
    // Execute lua files in order
    luaMan.run();
}

void MetatronsGrooveApp::fileDrop( FileDropEvent event )
{
    std::stringstream ss;
	ss << "You dropped files @ " << event.getPos() << " and the files were: " << std::endl;
	for( size_t s = 0; s < event.getNumFiles(); ++s )
		ss << event.getFile( s ) << std::endl;
	console() << ss.str() << std::endl;
}

int kbhit()
{
    struct timeval tv;
    fd_set fds;
    tv.tv_sec = 0;
    tv.tv_usec = 0;
    FD_ZERO(&fds);
    FD_SET(STDIN_FILENO, &fds); //STDIN_FILENO is 0
    select(STDIN_FILENO+1, &fds, NULL, NULL, &tv);
    return FD_ISSET(STDIN_FILENO, &fds);
}

void MetatronsGrooveApp::lua_prompt(){
    std::string usr_input = "";
    
    std::cout<< "> ";
    while( !exiting ){
        
        //non-blocking, so we can quit cleanly.
        if( !kbhit() ){ //kbhit returns true if enter is pressed
            std::this_thread::sleep_for (std::chrono::milliseconds(10));
            continue;
        }
        
        getline(std::cin, usr_input);
        luaMan.dostring(usr_input); //handles errors on its own
        std::cout<<"> ";
        usr_input = "";
    }
}

void MetatronsGrooveApp::setup()
{
    runLua();
    
    luabridge::LuaRef setup = luabridge::getGlobal(L,"setup");
    try{
        setup();
        //console()<<"[C++] Called Lua setup()."<<endl;
    }catch(luabridge::LuaException const& e){
        //console()<<"[C++] No Lua setup() function defined, skipping." <<endl;
    }
    
    lua_prompt_thread = std::thread(&MetatronsGrooveApp::lua_prompt,this);
    
    gl::clear();
}

void MetatronsGrooveApp::mouseDown( MouseEvent event )
{
}

void MetatronsGrooveApp::keyDown( KeyEvent event )
{
    
	if( event.getCode() == event.KEY_ESCAPE )
		exit();
}

void MetatronsGrooveApp::update()
{
}

void MetatronsGrooveApp::draw()
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

void MetatronsGrooveApp::exit(){
    exiting = true;
    lua_prompt_thread.join();
    quit();
}


CINDER_APP_NATIVE( MetatronsGrooveApp, RendererGl )
