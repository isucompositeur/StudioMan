//
//  AFCalendarControlCell.m
//  AFCalendarControl
//
//  Created by Keith Duncan on 02/09/2007.
//  Copyright 2007 thirty-three. All rights reserved.
//

#import "AFCalendarControlCell.h"

#import "CoreAmberKit/CoreAmberKit.h"

@interface AFCalendarControlCell (PrivateDrawing)
- (NSColor *)_textColor;
- (NSColor *)_shadowColor;
- (void)_drawBezelWithFrame:(NSRect)frame inView:(NSView *)view;
@end

@implementation AFCalendarControlCell

@synthesize today=_today, selected=_selected;

- (id)init {
	[super init];
	
	[self setFont:[NSFont fontWithName:@"Helvetica Bold" size:1]];
	
	return self;
}

- (NSRect)titleRectForBounds:(NSRect)bounds {
	NSRect drawingRect;
	
	drawingRect = [self drawingRectForBounds:bounds];
	drawingRect = NSInsetRect(drawingRect, 0.0, NSHeight(drawingRect)/5.0);
    drawingRect = NSOffsetRect(drawingRect, 0, -(NSHeight(bounds)/15.0));
	
	return drawingRect;
}

- (void)drawWithFrame:(NSRect)frame inView:(NSView *)view {
	[self _drawBezelWithFrame:frame inView:view];
	[super drawWithFrame:frame inView:view];
}

- (void)drawInteriorWithFrame:(NSRect)frame inView:(NSView *)view {
	[NSGraphicsContext saveGraphicsState];
	
	NSShadow *shadow = [[NSShadow alloc] init];
	[shadow setShadowColor:[self _shadowColor]];
	[shadow setShadowOffset:NSMakeSize(0, -1)];
	[shadow setShadowBlurRadius:0.0];
	[shadow set];
	
	NSRect textBounds = [self titleRectForBounds:frame];
	
	[[self _textColor] set];
	AKDrawStringAlignedInFrame([self stringValue], [self font], NSCenterTextAlignment, textBounds);
	
	if ([self isHighlighted]) {
		NSRect dotRect = frame;
		dotRect.size.height = NSMinY(textBounds) - NSMinY(frame);
		dotRect = AFRectCenteredSquare(dotRect, NSHeight(dotRect) * (1.0/3.0));
		
		[[self _textColor] set];
		[[NSBezierPath bezierPathWithOvalInRect:dotRect] fill];
	}
	
	[shadow release];
	
	[NSGraphicsContext restoreGraphicsState];
}

@end

@implementation AFCalendarControlCell (PrivateDrawing)

- (NSColor *)_textColor {
	if ([self isSelected] || [self isToday]) return [NSColor whiteColor];
	else if ([self isEnabled]) return [NSColor colorWithCalibratedWhite:(51.0/255.0) alpha:1.0];
	else return [NSColor colorWithCalibratedWhite:(169.0/255.0) alpha:1.0];
}

- (NSColor *)_shadowColor {
	if ([self isSelected] || [self isToday]) return [NSColor colorWithCalibratedRed:(13.0/255.0) green:(59.0/255.0) blue:(104.0/255.0) alpha:1.0];
	else return [NSColor whiteColor];
}

- (void)_applyTodayShadow:(NSBezierPath *)bezel {
	NSShadow *interiorShadow = [[NSShadow alloc] init];
	[interiorShadow setShadowColor:[NSColor shadowColor]];
	[interiorShadow setShadowBlurRadius:4.0];
	
    [bezel applyInnerShadow:interiorShadow];
	/*// Bottom and left sides
	[interiorShadow setShadowOffset:NSMakeSize(0,0)];
	[bezel applyInnerShadow:interiorShadow];
	
	// Top and right sides
	[interiorShadow setShadowOffset:NSMakeSize(-1,-1)];
	[bezel applyInnerShadow:interiorShadow];*/
	
	[interiorShadow release];
}

- (void)_drawBezelWithFrame:(NSRect)frame inView:(NSView *)view {
	if (![self isEnabled]) return;
	
	NSBezierPath *bezel = [NSBezierPath bezierPathWithRect:frame];
	
	BOOL drawKey = [[view window] isKeyWindow];
	
	if ([self isToday] && [self isSelected]) {
		if (drawKey) {
			[[NSColor colorWithCalibratedRed:(40.0/255.0) green:(100.0/255.0) blue:(240.0/255.0) alpha:1.0] set];
		} else {
			[[NSColor colorWithCalibratedWhite:(114.0/255.0) alpha:1.0] set];
		}
		
		[bezel fill];
		[self _applyTodayShadow:bezel];
	} else if ([self isToday] && ![self isSelected]){
		if (drawKey) {
			[[NSColor colorWithCalibratedRed:(100.0/255.0) green:(126.0/255.0) blue:(166.0/255.0) alpha:1.0] set];
		} else {
			[[NSColor colorWithCalibratedWhite:(127.0/255.0) alpha:1.0] set];
		}
		
		[bezel fill];
		[self _applyTodayShadow:bezel];
	} else if (![self isToday] && [self isSelected]) {
		if (drawKey) {

            NSColor *baseColor = [NSColor alternateSelectedControlColor];
            NSColor *highlightColor = [NSColor selectedControlColor];
			
            NSGradient *gradient = [[NSGradient alloc] initWithColorsAndLocations:baseColor,0.38,highlightColor,1.0, nil];

			[gradient drawInBezierPath:bezel angle:90];
			[gradient release];
		} else {
			NSGradient *gradient = [[NSGradient alloc] initWithColorsAndLocations:[NSColor colorWithCalibratedWhite:(176.0/255.0) alpha:1.0], 0.0, [NSColor colorWithCalibratedWhite:(121.0/255.0) alpha:1.0], 0.5, [NSColor colorWithCalibratedWhite:(113.0/255.0) alpha:1.0], 0.51, nil];
			[gradient drawInBezierPath:bezel angle:-90];
			[gradient release];
		}
        	} else if (![self isToday] && ![self isSelected]) { /* the cell is enabled */
		if (drawKey) {
			[[NSColor colorWithCalibratedRed:(187.0/255.0) green:(195.0/255.0) blue:(204.0/255.0) alpha:1.0] set];
			[bezel fill];
		} else {
			[[NSColor colorWithCalibratedWhite:(210.0/255.0) alpha:1.0] set];
			[bezel fill];
		}
	}
    
    if(![self isToday]) {
        [NSGraphicsContext saveGraphicsState];
        [[NSGraphicsContext currentContext] setShouldAntialias:NO];
        
        NSBezierPath *highlightPath = [[NSBezierPath alloc] init];
        [highlightPath setLineWidth:1.0];
        [highlightPath moveToPoint:NSMakePoint(NSMinX(frame) + 1, NSMinY(frame) + 1)];
        [highlightPath lineToPoint:NSMakePoint(NSMinX(frame) + 1, NSMaxY(frame) - 1)];
        [highlightPath lineToPoint:NSMakePoint(NSMaxX(frame) - 1, NSMaxY(frame) - 1)];
        
        [[NSColor colorWithCalibratedWhite:1.0 alpha:0.33] set];
        [highlightPath stroke];
        [NSGraphicsContext restoreGraphicsState];
    }
    
}

@end
