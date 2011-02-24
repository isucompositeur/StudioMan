//
//  AFGradientCell.h
//  AFSwitchControl
//
//  Created by Keith Duncan on 06/07/2008.
//  Copyright 2008 thirty-three software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/*
	@brief	A very simple cell subclass which draws a gray gradient (the one seen in <tt>AFGradientButton</tt> and <tt>AFSwitchControl</tt>) in a provided rect with rounded corners.
 */
@interface AFGradientCell : NSButtonCell {
	CGFloat _cornerRadius;
}

/*
	@brief	This property must be set before drawing with either <tt>-drawWithFrame:inView:</tt> or <tt>-drawBezelWithFrame:inView:</tt>.
 */
@property (assign) CGFloat cornerRadius;

/*
	@brief	The gradient is drawn in this method, allowing its user elsewhere without the text drawn too.
 */
- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)view;

@end
