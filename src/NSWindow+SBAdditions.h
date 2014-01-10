//
//  NSWindow+SBAdditions.h
//  CinderLua
//
//  Created by Stewart Bracken on 1/10/14.
//
//

#import <Cocoa/Cocoa.h>

@interface NSWindow (SBAdditions)
- (CGFloat)sb_toolbarHeight;
- (void)sb_resizeToSize:(NSSize)newSize;
@end
