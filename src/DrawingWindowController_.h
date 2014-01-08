//
//  MyController.h
//  CCGLBasic example
//
//  Created by Matthieu Savary on 03/03/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGL project >> http://cocoacid.org/ios/
//  License & disclaimer >> see license.txt file included in the distribution package
//

#import <Cocoa/Cocoa.h>
#import "MyCCGLDrawing.h"
#import "GLWindowController.h"


@interface DrawingWindowController : NSObject {
    @private
    IBOutlet NSButton* stopButton;
    IBOutlet NSButton* runButton;
    IBOutlet NSTextView* codeTextView;
    
    GLWindowController* glControllerWindow;
}


- (IBAction) runButtonListener: (id) sender;
- (IBAction) stopButtonListener: (id) sender;

@end