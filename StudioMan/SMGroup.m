//
//  Group.m
//  StudioMan
//
//  Created by Nicholas Meyer on 3/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SMGroup.h"


@implementation SMGroup
@dynamic groupName;
@dynamic term;
@dynamic people;


- (void)addPeopleObject:(NSManagedObject *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"people" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"people"] addObject:value];
    [self didChangeValueForKey:@"people" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removePeopleObject:(NSManagedObject *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"people" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"people"] removeObject:value];
    [self didChangeValueForKey:@"people" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addPeople:(NSSet *)value {    
    [self willChangeValueForKey:@"people" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"people"] unionSet:value];
    [self didChangeValueForKey:@"people" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removePeople:(NSSet *)value {
    [self willChangeValueForKey:@"people" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"people"] minusSet:value];
    [self didChangeValueForKey:@"people" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

#pragma mark -
#pragma mark Overridden SMGroup methods

- (NSString *)displayText
{
    return self.groupName;
}


@end
