//
//  Group.m
//  StudioMan
//
//  Created by Nicholas Meyer on 3/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SMGroupMO.h"
#import "SMPersonMO.h"

@implementation SMGroupMO
@dynamic groupName;
@dynamic term;
@dynamic people;

- (void)awakeFromInsert {
    mirrorRecord = [[ABGroup alloc] initWithAddressBook:[ABAddressBook sharedAddressBook]];
    [[ABAddressBook sharedAddressBook] addRecord:mirrorRecord];
}

- (void)addPeopleObject:(SMPersonMO *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"people" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"people"] addObject:value];
    [self didChangeValueForKey:@"people" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
    [(ABGroup *) mirrorRecord addMember:(ABPerson *)[[ABAddressBook sharedAddressBook] recordForUniqueId:value.uniqueId]];
}

- (void)removePeopleObject:(SMPersonMO *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"people" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"people"] removeObject:value];
    [self didChangeValueForKey:@"people" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
    [(ABGroup *)mirrorRecord removeMember:(ABPerson *)[[ABAddressBook sharedAddressBook] recordForUniqueId:value.uniqueId]];
}

- (void)addPeople:(NSSet *)value {    
    [self willChangeValueForKey:@"people" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"people"] unionSet:value];
    [self didChangeValueForKey:@"people" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    for (SMPersonMO *person in value) {
        [(ABGroup *)mirrorRecord addMember:(ABPerson *)[[ABAddressBook sharedAddressBook] recordForUniqueId:person.uniqueId]];
    }
}

- (void)removePeople:(NSSet *)value {
    [self willChangeValueForKey:@"people" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"people"] minusSet:value];
    [self didChangeValueForKey:@"people" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    for (SMPersonMO *person in value) {
        [(ABGroup *)mirrorRecord removeMember:(ABPerson *)[[ABAddressBook sharedAddressBook] recordForUniqueId:person.uniqueId]];
    }
}

#pragma mark -
#pragma mark Transient properties

- (NSString *)displayText
{
    return self.groupName;
}


@end
