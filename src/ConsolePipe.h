//
//  ConsolePipe.h
//  CinderLua
//
//  Created by Stewart Bracken on 12/20/13.
//  Copyright (c) 2013 Stewart Bracken. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef int (File_writer_t)(void*, const char*, int);

@interface ConsolePipe : NSTextView
{
    //NSTask       * task;
    //NSPipe       * pipe;
    //NSFileHandle * fileHandle;
    File_writer_t  * originalFW;
}

static int myOwnWriter( void *inFD, const char *buffer, int size );

@end
