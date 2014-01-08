//
//  MyController.mm
//  CCGLBasic example
//
//  Created by Matthieu Savary on 03/03/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGL project >> http://cocoacid.org/ios/
//  License & disclaimer >> see license.txt file included in the distribution package
//

#import "DrawingWindowController.h"
#import "GLWindowController.h"


@implementation DrawingWindowController

- (IBAction) listenToCubeSizeSlider: (NSSlider*) sender
{
	int value = [sender intValue];
	//[CinderDrawing setCubeSize:value];
    //[CinderDrawing setNeedsDisplay:YES]; // to show effect right away while sliding
    glControllerWindow = nil;
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
