//
//  DrawingDocument.h
//  CinderLua
//
//  Created by Stewart Bracken on 1/7/14.
//
//

#import <Cocoa/Cocoa.h>

#import "GLWindowController.h"

@interface DrawingDocument : NSDocument{
@private
    IBOutlet NSButton* stopButton;
    IBOutlet NSButton* runButton;
    IBOutlet NSTextView* codeTextView;
    
    GLWindowController* glControllerWindow;
}


- (IBAction) runButtonListener: (id) sender;
- (IBAction) stopButtonListener: (id) sender;

@end
