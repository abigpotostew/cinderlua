//
//  GLWindowController.h
//  CinderLua
//
//  Created by Stewart Bracken on 12/31/13.
//  Copyright (c) 2013 Stewart Bracken. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MyCCGLDrawing.h"

@interface GLWindowController : NSWindowController{
    IBOutlet MyCCGLDrawing *CinderDrawing;
}
@end
