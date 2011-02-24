//
//  IconTextCell.m
//  Amber
//
//  Created by Keith Duncan on 04/05/2007.
//  Copyright 2007 thirty-three. All rights reserved.
//

#import "AFImageTextCell.h"

#import "AFGeometry.h"

@implementation AFImageTextCell

@synthesize image=_image;

- (void)dealloc {
	self.image = nil;
	
	[super dealloc];
}

- (NSRect)imageRectForBounds:(NSRect)frame {
	NSRect imageFrame = frame;
	imageFrame.size.width = NSHeight(frame);
	
	return imageFrame;
}

- (NSRect)titleRectForBounds:(NSRect)bounds {
	NSRect titleRect = [super titleRectForBounds:bounds];
	if (self.image == nil) return titleRect;
	
	NSRect imageRect = [self imageRectForBounds:bounds];
	
	titleRect.origin.x = NSMaxX(imageRect);
	titleRect.size.width = (NSWidth(bounds) - NSWidth(imageRect));
	
	return titleRect;
}

- (void)drawWithFrame:(NSRect)frame inView:(NSView *)view {
	if (self.image != nil) {
		NSRect imageFrame = [self imageRectForBounds:frame];
		
		BOOL imageFlipped = [self.image isFlipped];
		[self.image setFlipped:YES];
		
		{
			[NSGraphicsContext saveGraphicsState];
			[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
			
			[self.image drawInRect:AFRectCenteredSquare(imageFrame, (NSHeight(frame) * (3.0/4.0))) fromRect:NSMakeRect(0, 0, [self.image size].width, [self.image size].height) operation:NSCompositeSourceOver fraction:1.0];
			
			[NSGraphicsContext restoreGraphicsState];
		}
		
		[self.image setFlipped:imageFlipped];
	}
	
	[self drawInteriorWithFrame:frame inView:view];
}

@end
