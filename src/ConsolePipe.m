//
//  ConsolePipe.m
//  CinderLua
//
//  Created by Stewart Bracken on 12/20/13.
//  Copyright (c) 2013 Stewart Bracken. All rights reserved.
//

#import "ConsolePipe.h"



static ConsolePipe* p;

@implementation ConsolePipe

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        File_writer_t *originalFW = stdout->_write;
        stdout->_write = &myOwnWriter ;
        //someRoutineWhichUsesFprinf( arg1, verbosity );
        //stderr->_write = originalFW ;
        p = self;
        [super setEditable: FALSE];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

static int myOwnWriter( void *inFD, const char *buffer, int size ){
    NSString *tmp = [ [ NSString alloc ] initWithBytes: buffer length:
                     size encoding: NSUTF8StringEncoding ];
    // do what you need with the tmp string here like appending it to a
    //NSTextView
    [p setEditable: TRUE];
    [p insertText:tmp];
    [p setEditable: FALSE];
    
    [tmp release ];
    return size ;
}

@end
