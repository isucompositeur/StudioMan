//
//  SourceItem.h
//  Amber
//
//  Created by Keith Duncan on 20/05/2007.
//  Copyright 2007 thirty-three. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/*
	@brief
 
	A node subclass suitable for source list structures.
 */
@interface AFSourceNode : NSTreeNode {
 @private
	NSString *_name;	
	NSUInteger _type, _position;
}

+ (id)sourceNodeWithName:(NSString *)name representedObject:(id)representedObject;
- (id)initWithName:(NSString *)name representedObject:(id)representedObject;

- (void)setType:(NSUInteger)type position:(NSUInteger)positon;

@property (copy) NSString *name;
@property (assign) NSUInteger type, position;

/*
	@brief
	
	NSTreeNode is an AppKit class so the image representation can be presentation-layer specific.
 */
@property (readonly) NSImage *image;

@end
