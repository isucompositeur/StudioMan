//
//  AFWeekSegmentCell.m
//  AFCalendarControl
//
//  Created by Keith Duncan on 01/09/2008.
//  Copyright 2008 thirty-three software. All rights reserved.
//

#import "AFWeekSegmentCell.h"

#import "CoreAmberKit/CoreAmberKit.h"

@interface AFWeekSegmentCell (Private)
- (CGFloat)_bezelRadiusForFrame:(NSRect)frame;
- (void)_drawBezelWithFrame:(NSRect)frame inView:(NSView *)view;
@end

@interface AFWeekSegmentCell (PrivateDrawing)
- (NSColor *)_highlightBlend;
@end

@implementation AFWeekSegmentCell

- (id)init {
	[super init];
	
	[self setFont:[NSFont systemFontOfSize:1]];
	
	return self;
}

- (void)drawWithFrame:(NSRect)frame inView:(NSView *)view {
	frame = NSInsetRect(frame, 3, 3);
	
	[self _drawBezelWithFrame:frame inView:view];
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
	NSString *string = [self stringValue];
	if (string == nil || [string isEmpty]) return;
	string = [string substringToIndex:1];
	
	[NSGraphicsContext saveGraphicsState];
	
	NSShadow *selectedTextShadow = [[NSShadow alloc] init];
	[selectedTextShadow setShadowOffset:NSMakeSize(0, -2)];
	[selectedTextShadow setShadowBlurRadius:3.0];
	
	NSColor *textColor = nil;
	if ([self state] == NSOnState || [self isHighlighted]) {
		textColor = [NSColor whiteColor];
		[selectedTextShadow set];
	} else {
		textColor = [NSColor darkGrayColor];
	}
	[textColor set];
	
	[selectedTextShadow release];
	
	_AKDrawStringAlignedInFrame(string, [self font], NSCenterTextAlignment, frame);
	
	[NSGraphicsContext restoreGraphicsState];
}

@end

@implementation AFWeekSegmentCell (Private)

- (CGFloat)_bezelRadiusForFrame:(NSRect)frame {
	return NSWidth(frame)/10.0;
}

- (void)_drawBezelWithFrame:(NSRect)frame inView:(NSView *)view {
	CGFloat radius = [self _bezelRadiusForFrame:frame];
	NSBezierPath *bezel = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:radius yRadius:radius];
	
	if ([self state] != NSOnState) {
		NSColor *fillColor = [NSColor colorWithCalibratedWhite:(250.0/255.0) alpha:1.0];
		
		NSColor *highlightBlend = [self _highlightBlend];
		if (highlightBlend != nil) {
			fillColor = [fillColor blendedColorWithFraction:1.0 ofColor:highlightBlend];
		}
		
		[fillColor set];
		[bezel fill];
	} else {
		if ([[view window] isKeyWindow]) {
			NSGradient *gradient = [NSGradient sourceListSelectionGradient:YES];
			[gradient drawInBezierPath:bezel angle:-90];
		} else {
			NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:(130.0/255.0) alpha:1.0] endingColor:[NSColor colorWithCalibratedWhite:(180.0/255.0) alpha:1.0]];
			[gradient drawInBezierPath:bezel angle:90];
			[gradient release];
		}
		
		NSColor *highlightBlend = [self _highlightBlend];
		if (highlightBlend != nil) {
			[highlightBlend set];
			[bezel fill];
		}
	}
	
	[[NSColor lightGrayColor] set];
	[bezel stroke];
	
	NSShadow *interiorShadow = [[NSShadow alloc] init];
	
	if ([self state] == NSOnState) {
		[interiorShadow setShadowColor:[NSColor blackColor]];
	} else {
		[interiorShadow setShadowColor:[NSColor grayColor]];
	}
	
	[interiorShadow setShadowOffset:NSMakeSize(0, -NSHeight(frame)/50.0)];
	[interiorShadow setShadowBlurRadius:NSHeight(frame)/40.0];
	
	[bezel applyInnerShadow:interiorShadow];
	
	[interiorShadow release];
}

@end

@implementation AFWeekSegmentCell (PrivateDrawing)

- (NSColor *)_highlightBlend {
	if ([self state] != NSOnState) {
		return ([self isHighlighted] ? [NSColor colorWithCalibratedWhite:0.5 alpha:0.2] : nil);
	} else {
		return ([self isHighlighted] ? [NSColor colorWithCalibratedWhite:0.2 alpha:0.2] : nil);
	}
	
	return nil;
}

@end
