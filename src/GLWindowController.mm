//
//  GLWindowController.m
//  CinderLua
//
//  Created by Stewart Bracken on 12/31/13.
//  Copyright (c) 2013 Stewart Bracken. All rights reserved.
//

#import "GLWindowController.h"

@interface GLWindowController ()

@end

@implementation GLWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        //NSLog(@"Creating new gl window");
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib
    
    // Get user specified window size
    int newWidth = [self->cinderDrawingView getWidth];
    int newHeight = [self->cinderDrawingView getHeight];
    
    // Resize window to user specified dimensions from lua.
    NSRect windowFrame = [self.window frame];
    [self.window setFrame:NSMakeRect(windowFrame.origin.x-newWidth/2, windowFrame.origin.y-newHeight/2, newWidth, newHeight) display:TRUE];
    [self.window setMinSize:[self.window frame].size];
    [self.window setMaxSize:[self.window frame].size];
    
    // Resize the drawing view
    NSRect f = [self->cinderDrawingView frame];
    f.size.width = newWidth;
    f.size.height = newHeight;
    f.origin.x = 0; // bottom
    f.origin.y = 0; // left
    self->cinderDrawingView.frame = f;
    
    // Prevent window resizing.
    [self.window setMinSize:[self.window frame].size];
    [self.window setMaxSize:[self.window frame].size];
    
    [self showWindow:self];
}

@end
