//
//  AFSwitchControl.h
//  AFSwitchControl
//
//  Created by Keith Duncan on 26/01/2008.
//  Copyright 2008 thirty-three. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AmberKit/AFKeyValueBinding.h"

@class AFGradientCell;

/*
	@brief
			A TimeMache.prefPane style big button control. Also seen in 'Server Preferences.app'.
			It uses a simple linear animation to indicate the change in value.
	
	@detail
			This class exposes a single binding <tt>NSValueBinding</tt> which should be an object responding
			to <tt>-boolValue</tt> which determines the current state of the button.
 */
@interface AFSwitchControl : NSControl <AFKeyValueBinding> {
	NSMutableDictionary *_bindingInfo;
	CGFloat _offset;
}

@property (readwrite, retain) AFGradientCell *cell;

/*
	@result	The button state values, NSOnState or NSOffState.
 */
@property (assign) NSUInteger state;

@end
