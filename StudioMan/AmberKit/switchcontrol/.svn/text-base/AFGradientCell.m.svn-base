//
//  AFGradientCell.m
//  AFSwitchControl
//
//  Created by Keith Duncan on 06/07/2008.
//  Copyright 2008 thirty-three software. All rights reserved.
//

#import "AFGradientCell.h"

#import "AmberKit/AmberKit+Additions.h"

@implementation AFGradientCell

@synthesize cornerRadius=_cornerRadius;

- (void)drawWithFrame:(NSRect)frame inView:(NSView *)view {	
	[NSGraphicsContext saveGraphicsState];
	
	NSShadow *handleShadow = [[NSShadow alloc] init];
	[handleShadow setShadowColor:[NSColor whiteColor]];
	[handleShadow setShadowOffset:NSMakeSize(0, -2)];
	[handleShadow setShadowBlurRadius:0];
	[handleShadow set];
	
	NSRect interiorRect = NSInsetRect(frame, 4, 4);
	
	[self drawBezelWithFrame:interiorRect inView:view];
	
	[super drawWithFrame:interiorRect inView:view];
	
	[handleShadow release];
	
	[NSGraphicsContext restoreGraphicsState];
}

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)view {
	[NSGraphicsContext saveGraphicsState];
	
	NSBezierPath *handle = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:self.cornerRadius yRadius:self.cornerRadius];
	
	NSGradient *handleGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:(252.0/255.0) alpha:1.0] endingColor:[NSColor colorWithCalibratedWhite:(214.0/255.0) alpha:1.0]];
	[handleGradient drawInBezierPath:handle angle:([self isHighlighted] ? 90 : -90)];
	[handleGradient release];
	
	[[NSColor grayColor] set];
	[handle stroke];
	
	[NSGraphicsContext restoreGraphicsState];
}

- (void)drawInteriorWithFrame:(NSRect)frame inView:(NSView *)view {
	NSRect interiorRect = NSInsetRect(frame, 0, NSHeight(frame)/6.0);
	
	[[NSColor colorWithCalibratedWhite:0.2 alpha:1.0] set];
	AKDrawStringAlignedInFrame([self title], [self font], NSCenterTextAlignment, interiorRect);
}

@end
