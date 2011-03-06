/******************************************************************************
 *                                                                            *
 * StudioMan: Music studio management software                                *
 *                                                                            *
 * Copyright (C) 2011 Nicholas Meyer                                          *               
 *                                                                            *
 * This file is part of StudioMan.                                            *
 *                                                                            *
 * StudioMan is free software: you can redistribute it and/or modify it under *
 * the terms of the GNU General Public License as published by the Free       *
 * Software Foundation, either version 3 of the License, or (at your option)  *
 * any later version.                                                         *
 *                                                                            *
 * StudioMan is distributed in the hope that it will be useful, but WITHOUT   *
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or      *
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for  *
 * more details.                                                              *
 *                                                                            *
 * You should have received a copy of the GNU General Public License along    *
 * with StudioMan.  If not, see <http://www.gnu.org/licenses/>.               *
 *                                                                            *
 ******************************************************************************/

/******************************************************************************
 *                                                                            *
 * NSSplitView Additions                                                      *
 * StudioMan                                                                  *
 *                                                                            *
 * This category adds methods to NSSplitView to facilitated animated subview  *
 * collapsing. It also defines an extension to the NSSplitViewDelegate        *
 * protocol for storing view frames for when they are uncollapsed.            *
 *                                                                            *
 ******************************************************************************/

#import <QuartzCore/QuartzCore.h>
#import "NSSplitView+Additions.h"

static const NSTimeInterval SMSubviewToggleAnimationDurationDefault = 0.2;

@implementation NSSplitView (SMAdditions)

- (void) toggleSubview:(NSView*)subview withDuration:(NSTimeInterval) duration
{
    NSUInteger viewIndex = [[self subviews] indexOfObject:subview];
    NSRect viewTargetFrame;
    
    id <NSSplitViewDelegateAdditions> addDelegate = (id <NSSplitViewDelegateAdditions>)[self delegate];
    
    if([self isCollapsing:subview]) {
        
        [addDelegate setOriginalRect:[subview frame] forSubview:subview];
        
        if([self isVertical]) {
            switch(viewIndex) {
                case 0:
                    viewTargetFrame = NSMakeRect(subview.frame.origin.x, subview.frame.origin.y, 0, subview.frame.size.height);
                    break;
                case 1:
                    viewTargetFrame = NSMakeRect(NSMaxX([self bounds]), subview.frame.origin.y, 0, subview.frame.size.height);
                    break;
            }
        } else {
            switch(viewIndex) {
                case 0:
                    viewTargetFrame = NSMakeRect(subview.frame.origin.x, subview.frame.origin.y, subview.frame.size.width, 0);
                    break;
                case 1:
                    viewTargetFrame = NSMakeRect(subview.frame.origin.x, NSMaxY([self bounds]), subview.frame.size.width, 0);
            }
            
        }
    } else {
        viewTargetFrame = [addDelegate originalRectForSubview:subview];
    }
    
    NSMutableDictionary *newAnimations = [NSMutableDictionary dictionary];
    [newAnimations addEntriesFromDictionary:[subview animations]];
    [newAnimations setObject:[self collapseAnimation:subview] forKey:@"frameOrigin"];
    [newAnimations setObject:[self collapseAnimation:subview] forKey:@"frameSize"];
    [subview setAnimations:newAnimations];
    
    [[subview animator] setFrame:viewTargetFrame];

}

- (void)toggleSubview:(NSView *)subView
{
    [self toggleSubview:subView withDuration:SMSubviewToggleAnimationDurationDefault];
}

- (CABasicAnimation *)collapseAnimation:(NSView *)subview
{
    CABasicAnimation *anim = [CABasicAnimation animation];
    [anim setDuration:SMSubviewToggleAnimationDurationDefault];
    if([self isCollapsing:subview]) {
        [anim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    } else {
        [anim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    }
    return anim;
}

- (BOOL)isCollapsing:(NSView *)subview
{
    BOOL isCollapsing;
    if ([self isVertical]) {
        [subview frame].size.width == 0 ? (isCollapsing = NO) : (isCollapsing = YES);
    } else {
        [subview frame].size.height == 0 ? (isCollapsing = NO) : (isCollapsing = YES);
    }
    return isCollapsing;
}

@end
