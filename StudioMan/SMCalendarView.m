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
 * SMCalendarView                                                             *
 * StudioMan                                                                  *
 *                                                                            *
 * This class implements a large datebook-style calendar view, similar to the *
 * main view of Apple's iCal.                                                 *
 *                                                                            *
 ******************************************************************************/

#import "SMCalendarView.h"


@implementation SMCalendarView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)isFlipped
{
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] set];
    NSBezierPath *framePath = [NSBezierPath bezierPathWithRect:[self bounds]];
    [framePath fill];
    
    [[NSGraphicsContext currentContext] saveGraphicsState];
    [[NSGraphicsContext currentContext] setShouldAntialias:NO];
    
    NSBezierPath *gridPath = [[NSBezierPath alloc] init];
    
    [gridPath moveToPoint:NSMakePoint(0, 0)];
    
    [gridPath lineToPoint:NSMakePoint([self bounds].size.width, 0)];
    
    [[NSColor blackColor] set];
    
    [gridPath stroke];
    
    [[NSGraphicsContext currentContext] restoreGraphicsState];
    // Drawing code here.
}

@end
