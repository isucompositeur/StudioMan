//
//  DisclosureCell.h
//  Amber
//
//  Created by Keith Duncan on 22/05/2007.
//  Copyright 2007 thirty-three. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AFDisclosureCell;

/*
	@brief
 
	This class draws a disclosure button identical to the AppKit one.
	However, it includes externally customisable |cellColor| and |shadowColor| properties
	which make it suitable for inclusion in a table view.
 */
@interface AFDisclosureButton : NSButton

@property (retain) AFDisclosureCell *cell;

@end

@interface AFDisclosureCell : NSButtonCell {
 @private
	NSColor *cellColor, *shadowColor;
}

@property (retain) NSColor *cellColor, *shadowColor;

@end
