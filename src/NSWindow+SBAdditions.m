//
//  NSWindow+SBAdditions.m
//  CinderLua
//
//  Created by Stewart Bracken on 1/10/14.
//
//

#import "NSWindow+SBAdditions.h"

@implementation NSWindow (SBAdditions)
- (CGFloat)sb_toolbarHeight{
    NSToolbar *toolbar = [self toolbar];
    CGFloat toolbarHeight = 0.0;
    NSRect windowFrame;
    
    if (toolbar && [toolbar isVisible]) {
        windowFrame = [[self class] contentRectForFrameRect:[self frame]
                                                  styleMask:[self styleMask]];
        toolbarHeight = NSHeight(windowFrame) -
        NSHeight([[self contentView] frame]);
    }
    return toolbarHeight;
}

- (void)sb_resizeToSize:(NSSize)newSize{
    CGFloat newHeight = newSize.height + [self sb_toolbarHeight];
    CGFloat newWidth = newSize.width;
    
    NSRect aFrame = [[self class] contentRectForFrameRect:[self frame]
                                                styleMask:[self styleMask]];
    
    aFrame.origin.y += aFrame.size.height;
    aFrame.origin.y -= newHeight;
    aFrame.size.height = newHeight;
    aFrame.size.width = newWidth;
    
    aFrame = [[self class] frameRectForContentRect:aFrame
                                         styleMask:[self styleMask]];
    [self setFrame:aFrame display:YES animate:YES];
}
@end
