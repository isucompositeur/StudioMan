//
//  AFTextFieldCell.m
//  Amber
//
//  Created by Keith Duncan on 22/05/2007.
//  Copyright 2007 thirty-three. All rights reserved.
//

#import "AFTextFieldCell.h"

@implementation AFTextFieldCell

- (NSRect)titleRectForBounds:(NSRect)rect {
	NSRect titleRect = [super titleRectForBounds:rect];
	
	titleRect = NSInsetRect(titleRect, 2.0, (NSHeight(titleRect) - [self cellSizeForBounds:rect].height)/2.0);
	titleRect = NSOffsetRect(titleRect, -2.0, 0.0);
	
	return titleRect;
}

- (void)drawInteriorWithFrame:(NSRect)frame inView:(NSView *)view {
	frame = [self titleRectForBounds:frame];
	[super drawInteriorWithFrame:frame inView:view];
}

@end
