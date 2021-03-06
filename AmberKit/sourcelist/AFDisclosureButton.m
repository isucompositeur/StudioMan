//
//  DisclosureCell.m
//  Amber
//
//  Created by Keith Duncan on 22/05/2007.
//  Copyright 2007 thirty-three. All rights reserved.
//

#import "AFDisclosureButton.h"

#import "AFGeometry.h"

@implementation AFDisclosureButton

@dynamic cell;

+ (Class)cellClass {
	return [AFDisclosureCell class];
}

@end

@implementation AFDisclosureCell

@synthesize cellColor, shadowColor;

- (void)drawWithFrame:(NSRect)frame inView:(NSView *)view {
	[NSGraphicsContext saveGraphicsState];
	
	NSAffineTransform *transform = [NSAffineTransform transform];
	
	if ([self isHighlighted] || [self state] == NSOnState) {
		CGFloat deltaX = NSWidth(frame)/2.0, deltaY = NSHeight(frame)/2.0;
		
		[transform translateXBy:deltaX yBy:deltaY];
		
		CGFloat degrees = ([self state] == NSOnState ? 90 : 0);
		if ([self isHighlighted]) degrees += (([self state] == NSOnState ? -1 : 1) * 28);
		[transform rotateByDegrees:degrees];
		
		[transform translateXBy:-deltaX yBy:-deltaY];
		[transform concat];
	}
	
	NSRect buttonRect = AFRectCenteredSquare(frame, MIN(NSHeight(frame), NSWidth(frame)));
	
	NSBezierPath *trianglePath = [NSBezierPath bezierPath];
	[trianglePath moveToPoint:NSMakePoint(NSMinX(buttonRect), NSMaxY(buttonRect))];
	[trianglePath lineToPoint:NSMakePoint(NSMaxX(buttonRect), (NSMaxY(buttonRect)/2.0))];
	[trianglePath lineToPoint:NSMakePoint(NSMinX(buttonRect), NSMinY(buttonRect))];
	[trianglePath closePath];
	
	[trianglePath setClip];
	
	NSShadow *shadow = [[NSShadow alloc] init];
	[shadow setShadowColor:self.shadowColor];
	[shadow setShadowOffset:NSMakeSize(([self state] == NSOnState ? 1 : 0), ([self state] == NSOffState ? -1 : 0))];
	[shadow setShadowBlurRadius:0.0];
	[shadow set];
	[shadow release];
	
	[([self isHighlighted] ? [self.cellColor blendedColorWithFraction:0.2 ofColor:[NSColor blackColor]] : self.cellColor) set];
	[trianglePath fill];
	
	[NSGraphicsContext restoreGraphicsState];
}

@end
