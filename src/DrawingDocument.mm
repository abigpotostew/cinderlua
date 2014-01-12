//
//  DrawingDocument.m
//  This si a  combination of the model and controller for a cinder lua doc.
//
//  Created by Stewart Bracken on 1/7/14.
//
//

#import "DrawingDocument.h"

//private methods
@interface DrawingDocument ()
-(void)removeCinderView;
@end

@implementation DrawingDocument

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}


- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"DrawingDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    
    //[aController setShouldCloseDocument: YES];
    
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    
    if(!data_tmp) data_tmp = @"";
    if(codeTextView != nil)
        [self->codeTextView setString: data_tmp];
    
    [cinderDrawingView setConsoleOut: consoleTextView];
    
    [data_tmp release];
    data_tmp = nil;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSData *data;
    NSMutableDictionary *dict = [NSDictionary dictionaryWithObject:NSPlainTextDocumentType //NSRTFTextDocumentType
                                                            forKey:NSDocumentTypeDocumentAttribute];
    [codeTextView breakUndoCoalescing];
    data = [[codeTextView textStorage] dataFromRange:NSMakeRange(0, [[codeTextView textStorage] length])
                    documentAttributes:dict error:outError];
    if (!data && outError) {
        *outError = [NSError errorWithDomain:NSCocoaErrorDomain
                                        code:NSFileWriteUnknownError userInfo:nil];
    }
    return data;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.

    BOOL readSuccess = NO;
    //NSAttributedString *fileContents = [[NSAttributedString alloc]
    //                                    initWithData:data options:NULL documentAttributes:NULL
    //                                    error:outError];
    NSString* fileData = [[NSString alloc] initWithData:data encoding:[NSString defaultCStringEncoding] ];
    //[fileContents autorelease];
    
    if (!fileData && outError) {
        *outError = [NSError errorWithDomain:NSCocoaErrorDomain
                                        code:NSFileReadUnknownError userInfo:nil];
    }
    if (fileData) {
        readSuccess = YES;
        data_tmp = fileData;
    }
    return readSuccess;
}

+ (BOOL)autosavesInPlace
{
    return YES;
}


- (IBAction) runButtonListener: (id) sender
{
    [self closeGLWindow];
    
    const char* f_url = [[self fileURL] fileSystemRepresentation]; //10.9+ only
    [cinderDrawingView setLuaMainPath: f_url];
    
    [cinderDrawingView callSetupNewLuaState];
    
    //clear console
    [[consoleTextView textStorage] replaceCharactersInRange:
                                        NSMakeRange(0, [[consoleTextView textStorage] length])
                                   withString:@""];
    
    [gLWindow makeKeyAndOrderFront:nil];
}

- (IBAction) stopButtonListener: (id) sender
{
    [self closeGLWindow];
}

- (void) closeGLWindow
{
    if ( cinderDrawingView )
        [cinderDrawingView clearLuaState];
    if( gLWindow )
        [gLWindow close];
}

@end
