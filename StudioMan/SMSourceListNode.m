//
//  SMSourceListNode.m
//  StudioMan
//
//  Created by Nicholas Meyer on 3/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SMSourceListNode.h"


@implementation SMSourceListNode

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return [[self representedObject] valueForKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    [[self representedObject] setValue:value forUndefinedKey:key];
}

- (void)dealloc
{
    [super dealloc];
}

@end
