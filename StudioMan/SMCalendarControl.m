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
 * SMCalendarControl                                                          *
 * StudioMan                                                                  *
 *                                                                            *
 * This class is a subclass of NSControl which implements an iCal like        *
 * calendar control which can be used to select a date to review. This code   *
 * is based off of Keith Duncan's excellent AFCalendarControl class that is   *
 * part of the Amber Framework.                                               *
 *                                                                            *
 ******************************************************************************/

#import "SMCalendarControl.h"

static const NSUInteger _SMCalendarControlVisibleWeeks = 6;
static const CGFloat _SMCalendarMonthProportion = 4.8;

@implementation SMCalendarControl

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)awakeFromNib
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(display) name:NSWindowDidResignKeyNotification object:[self window]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(display) name:NSWindowDidBecomeKeyNotification object:[self window]];
}

# pragma mark -
# pragma mark Overridden NSView methods

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect bounds = [self bounds];
    // draw the background
    NSBezierPath *backgroundPath = [NSBezierPath bezierPathWithRect:bounds];

	[[NSColor lightGrayColor] set];
	[backgroundPath stroke];
    
    // delimiting the header and grid portions of the view
    NSRect headerRect, gridRect;
    NSDivideRect(bounds, &headerRect, &gridRect, NSHeight(bounds)/_SMCalendarMonthProportion, NSMaxYEdge);
    
    // drawing the month frame gradient--different if the window is not key
    BOOL isKey = [[self window] isKeyWindow];
    NSGradient *monthGradient = nil;
    
    if (isKey) {
		monthGradient = [[NSGradient alloc] initWithColorsAndLocations:
						 [NSColor colorWithCalibratedRed:(233.0/255.0) green:(237.0/255.0) blue:(242.0/255.0) alpha:1.0], 0.0,
						 [NSColor colorWithCalibratedRed:(210.0/255.0) green:(219.0/255.0) blue:(228.0/255.0) alpha:1.0], (NSHeight(headerRect)/NSHeight(bounds)),
						 [NSColor colorWithCalibratedRed:(191.0/255.0) green:(199.0/255.0) blue:(207.0/255.0) alpha:1.0], 1.0,
						 nil];
	} else {
		monthGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:(242.0/255.0) alpha:1.0] endingColor:[NSColor colorWithCalibratedWhite:(227.0/255.0) alpha:1.0]];
	}
    
    [monthGradient drawInBezierPath:backgroundPath angle:-90];
	[monthGradient release];
    
    // setting up the shadow highlight for the months display
    
    NSShadow *whiteShadow = [[NSShadow alloc] init];
	[whiteShadow setShadowColor:[NSColor whiteColor]];
	[whiteShadow setShadowOffset:NSMakeSize(0, -1.0)];
	[whiteShadow setShadowBlurRadius:0.0];
	
	[NSGraphicsContext saveGraphicsState];
	
	[whiteShadow set];
	[whiteShadow release];
    
    // splitting the header display into month, forward/back arrows, and day names
    
    NSRect headerMonthRect, headerDaysRect;
    NSDivideRect(headerRect, &headerMonthRect, &headerDaysRect, NSHeight(headerRect)*(3.4/5.0), NSMaxYEdge);
    headerMonthRect = NSInsetRect(headerMonthRect, NSWidth(headerMonthRect)/14.0, NSHeight(headerMonthRect)/3.8);
    headerDaysRect.origin.y = NSMinY(headerRect) + (NSHeight(headerRect)/20.0);
    
    NSRect buttonFrames[2];
    buttonFrames[0] = headerMonthRect;
    buttonFrames[0].size.width = NSMinX(headerMonthRect) - NSMinX(headerRect);
    buttonFrames[0].origin.x = NSMinX(headerRect) + ((1.0/2.0) * NSWidth(buttonFrames[0]));
    
    buttonFrames[1] = headerMonthRect;
    buttonFrames[1].size.width = NSMaxX(headerRect) - NSMaxX(headerMonthRect);
    buttonFrames[1].origin.x = NSMaxX(headerRect) - ((1.0/2.0) * NSWidth(buttonFrames[1]));

    [NSGraphicsContext restoreGraphicsState];
    
}

@end
