//
//  DrawingWindowController.m
//  CinderLua
//
//  Created by Stewart Bracken on 1/7/14.
//
//

#import "DrawingWindowController.h"

@interface DrawingWindowController ()

@end

@implementation DrawingWindowController


- (id)init {
    if (self = [super initWithWindowNibName:@"DocumentWindow"]) {

    }
    return self;
}


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
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction) runButtonListener: (id) sender
{
    NSLog(@"CLICKED!");
    if(glControllerWindow != nil){
        [glControllerWindow release];
    }
    glControllerWindow = [[GLWindowController alloc] initWithWindowNibName:@"GLWindow"];
    [glControllerWindow showWindow:self];
}

- (IBAction) stopButtonListener: (id) sender
{
    if(glControllerWindow != nil){
        [glControllerWindow release];
        glControllerWindow = nil;
    }
}

@end
