//
//  LuaBindings.h
//  MetatronsGroove
//
//  Created by Stewart Bracken on 12/19/13.
//
//

#ifndef MetatronsGroove_LuaBindings_h
#define MetatronsGroove_LuaBindings_h

#include <string>
#include "lua.hpp"

namespace luabindings{
//instanced for each Drawing
    class LuaWindow{
    private:
        int _width = 200, _height = 200;
        //std::string s;
    public:
        LuaWindow(int _w, int _h):_width(_w),_height(_h){}
        int width()const{return _width;}
        int height()const{return _height;}
        void size(int _w, int _h){
            _width = _w;
            _height = _h;
        }
    };
    class LuaApp{
    private:
        NSTextView* consoleOut;
    public:
        LuaApp(NSTextView* _consoleOut):consoleOut(_consoleOut){};
        LuaApp():consoleOut(nil){
        
        };
        LuaApp(const LuaApp& other){
            consoleOut = other.consoleOut;
        }
        void print_to_console_pipe(const std::string& message)const{
            if(consoleOut==nil){
                return;
            }
            NSString *tmp = [ [ NSString alloc ] initWithUTF8String:message.c_str() ];
            // do what you need with the tmp string here like appending it to a
            //NSTextView
            [consoleOut setEditable: TRUE];
            [consoleOut insertText:tmp];
            [consoleOut setEditable: FALSE];
            
            [tmp release ];
        }
    };

    void add_to_state(lua_State* L);
}
#endif
