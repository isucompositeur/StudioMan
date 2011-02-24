//
//  SourceItem.m
//  Amber
//
//  Created by Keith Duncan on 20/05/2007.
//  Copyright 2007 thirty-three. All rights reserved.
//

#import "AFSourceNode.h"

@implementation AFSourceNode

@synthesize name=_name;
@synthesize type=_type, position=_position;

+ (id)sourceNodeWithName:(NSString *)name representedObject:(id)representedObject {
	return [[[self alloc] initWithName:name representedObject:representedObject] autorelease];
}

- (id)initWithName:(NSString *)name representedObject:(id)representedObject {
	[self initWithRepresentedObject:representedObject];
	
	self.name = name;
	
	self.type = 0;
	self.position = 1;
		
	return self;
}

- (void)dealloc {
	self.name = nil;
			
	[super dealloc];
}

- (void)setType:(NSUInteger)type position:(NSUInteger)position {
	self.type = type;
	self.position = position;
}

- (NSImage *)image {
	return nil;
}

- (void)sortWithSortDescriptors:(NSArray *)sortDescriptors recursively:(BOOL)recursively {
	[[self mutableChildNodes] setArray:[[self childNodes] sortedArrayUsingDescriptors:sortDescriptors]];
	if (recursively) for (AFSourceNode *currentNode in [self childNodes]) [currentNode sortWithSortDescriptors:sortDescriptors recursively:recursively];
}

@end
