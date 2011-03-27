//
//  SMImageToDataTransformer.m
//  StudioMan
//
//  Created by Nicholas Meyer on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SMImageToDataTransformer.h"


@implementation SMImageToDataTransformer

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}

- (id)transformedValue:(id)value {
	NSData *data = [(NSImage *)value TIFFRepresentation];;
	return data;
}

- (id)reverseTransformedValue:(id)value {
	NSImage *image = [[NSImage alloc] initWithData:value];
	return [image autorelease];
}

@end
