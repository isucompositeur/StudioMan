//
//  AFGradientButton.m
//  AFGradientButton
//
//  Created by Keith Duncan on 06/07/2008.
//  Copyright 2008 thirty-three software. All rights reserved.
//

#import "AFGradientButton.h"

#import "AFGradientCell.h"

@implementation AFGradientButton

@dynamic cell;

+ (Class)cellClass {
	return [AFGradientCell class];
}

- (BOOL)isFlipped {
	return NO;
}

- (void)drawRect:(NSRect)frame {	
	[self cell].cornerRadius = NSHeight(frame)/6.0;
	
	[super drawRect:frame];
}

@end
