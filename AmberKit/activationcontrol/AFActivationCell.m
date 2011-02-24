//
//  AFActivationCell.m
//  AFActivationControl
//
//  Created by Keith Duncan on 01/09/2008.
//  Copyright 2008 thirty-three software. All rights reserved.
//

#import "AFActivationCell.h"

@interface AFActivationCell (Private)
- (CGFloat)_bezelRadiusForFrame:(NSRect)frame;
- (void)_drawBezelWithFrame:(NSRect)frame inView:(NSView *)view;
@end

@implementation AFActivationCell

- (id)init {
	self = [super init];
	if (self == nil) return nil;
	
	[self setFont:[NSFont systemFontOfSize:1]];
	
	return self;
}

- (void)drawWithFrame:(NSRect)frame inView:(NSView *)view {
	frame = NSInsetRect(frame, 3, 3);
	
	[self _drawBezelWithFrame:frame inView:view];
	[self highlight:[self isHighlighted] withFrame:frame inView:view];
	
	[self drawInteriorWithFrame:frame inView:view];
}

static void _AKDrawStringAlignedInFrame(NSString *text, NSFont *font, NSTextAlignment alignment, NSRect frame) {
	NSCParameterAssert(font != nil);
	
	NSBezierPath *textPath = [NSBezierPath bezierPathWithString:text inFont:font];
	
	NSRect textPathBounds = NSMakeRect(NSMinX([textPath bounds]), [font descender], NSWidth([textPath bounds]), [font ascender] - [font descender]);
	
	NSAffineTransform *scale = [NSAffineTransform transform];
	CGFloat xScale = NSWidth(frame)/NSWidth(textPathBounds);
	CGFloat yScale = NSHeight(frame)/NSHeight(textPathBounds);
	[scale scaleBy:MIN(xScale, yScale)];
	[textPath transformUsingAffineTransform:scale];
	
	textPathBounds.origin = [scale transformPoint:textPathBounds.origin];
	textPathBounds.size = [scale transformSize:textPathBounds.size];
	
	NSAffineTransform *originCorrection = [NSAffineTransform transform];
	NSPoint centeredOrigin = AFRectCenteredSize(frame, textPathBounds.size).origin;
	[originCorrection translateXBy:(centeredOrigin.x - NSMinX(textPathBounds)) yBy:(centeredOrigin.y - NSMinY(textPathBounds))];
	[textPath transformUsingAffineTransform:originCorrection];
	
	if (alignment != NSJustifiedTextAlignment && alignment != NSCenterTextAlignment) {
		NSAffineTransform *alignmentTransform = [NSAffineTransform transform];
		
		CGFloat deltaX = 0;
		if (alignment == NSLeftTextAlignment) deltaX = -(NSMinX([textPath bounds]) - NSMinX(frame));
		else if (alignment == NSRightTextAlignment) deltaX = (NSMaxX(frame) - NSMaxX([textPath bounds]));
		[alignmentTransform translateXBy:deltaX yBy:0];
		
		[textPath transformUsingAffineTransform:alignmentTransform];
	}
	
	[textPath fill];
}

- (void)drawInteriorWithFrame:(NSRect)frame inView:(NSView *)view {
	NSString *string = [self objectValue];
	if (string == nil || [string isEmpty]) return;
	string = [string substringToIndex:1];
	
	[[NSColor blackColor] set];
	_AKDrawStringAlignedInFrame(string, [self font], NSCenterTextAlignment, frame);
}

- (void)highlight:(BOOL)flag withFrame:(NSRect)frame inView:(NSView *)view {
	if (!flag) return;
	
	[NSBezierPath setDefaultLineWidth:3.0];
		
	CGFloat radius = [self _bezelRadiusForFrame:frame];
	NSBezierPath *bezel = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:radius yRadius:radius];
	
	if ([[view window] isKeyWindow])
		[[NSColor colorWithCalibratedRed:(41.0/255.0) green:(99.0/255.0) blue:(214.0/255.0) alpha:1.0] set];
	else
		[[NSColor grayColor] set];
	
	[bezel stroke];
	
	[NSBezierPath setDefaultLineWidth:1.0];
}

@end

@implementation AFActivationCell (Private)

- (CGFloat)_bezelRadiusForFrame:(NSRect)frame {
	return NSWidth(frame)/10.0;
}

- (void)_drawBezelWithFrame:(NSRect)frame inView:(NSView *)view {
	CGFloat radius = [self _bezelRadiusForFrame:frame];
	NSBezierPath *bezel = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:radius yRadius:radius];
	
	[[NSColor colorWithCalibratedWhite:(250.0/255.0) alpha:1.0] set];
	[bezel fill];
	
	[[NSColor lightGrayColor] set];
	[bezel stroke];
	
	NSShadow *interiorShadow = [[NSShadow alloc] init];
	[interiorShadow setShadowColor:[NSColor grayColor]];
	[interiorShadow setShadowOffset:NSMakeSize(0, -NSHeight(frame)/40.0)];
	[interiorShadow setShadowBlurRadius:NSHeight(frame)/40.0];
	
	[bezel applyInnerShadow:interiorShadow];
	
	[interiorShadow release];
}

@end
