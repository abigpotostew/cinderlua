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
    
    IBOutlet NSWindow* gLWindow;
    IBOutlet CinderDrawingView *cinderDrawingView;
    
    IBOutlet NSTextView* consoleTextView;
    
    //GLWindowController* glControllerWindow;
    
    NSString* data_tmp;
}


- (IBAction) runButtonListener: (id) sender;
- (IBAction) stopButtonListener: (id) sender;

-(CGFloat) toolbarHeight;
- (void)resizeToSize:(NSSize)newSize;

@end
