//
//  GLWindowController.m
//  CinderLua
//
//  Created by Stewart Bracken on 12/31/13.
//  Copyright (c) 2013 Stewart Bracken. All rights reserved.
//

#import "GLWindowController.h"
//
//@interface GLWindowController ()
//
//@end

@implementation GLWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib
    //CinderDrawingView = [[ DrawingView alloc ] initWithFrame:NSMakeRect(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    //[CinderDrawingView autorelease];
    //[CinderDrawingView setWantsLayer:YES];
    //[CinderDrawingView setCanDrawConcurrently:TRUE]; //?? untested
    
    //[self.window.contentView addSubview:CinderDrawingView];
    int newWidth = [self->CinderDrawingView getWidth];
    int newHeight = [self->CinderDrawingView getHeight];
    [self.window setFrame:NSMakeRect(0, 0, newWidth, newHeight) display:TRUE];
    NSRect f = self->CinderDrawingView.frame;
    f.size.width = newWidth;
    f.size.height = newHeight;
    self->CinderDrawingView.frame = f;
}

@end
