//
//  SMTermMO.m
//  StudioMan
//
//  Created by Nicholas Meyer on 3/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SMTermMO.h"
#import "SMGroupMO.h"

NSString * const SMABTermPrefix = @"StudioMan - ";

@implementation SMTermMO
@dynamic termName;
@dynamic groups;

- (void)awakeFromInsert
{
    mirrorRecord = [[ABGroup alloc] initWithAddressBook:[ABAddressBook sharedAddressBook]];
    [[ABAddressBook sharedAddressBook] addRecord:mirrorRecord];
    [super awakeFromInsert];
}

- (void)addGroupsObject:(SMGroupMO *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"groups" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"groups"] addObject:value];
    [self didChangeValueForKey:@"groups" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
    
    [(ABGroup *)mirrorRecord addSubgroup:(ABGroup *)[[ABAddressBook sharedAddressBook] recordForUniqueId:value.uniqueId]];
}

- (void)removeGroupsObject:(SMGroupMO *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"groups" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"groups"] removeObject:value];
    [self didChangeValueForKey:@"groups" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
    
    [(ABGroup *)mirrorRecord removeSubgroup:(ABGroup *)[[ABAddressBook sharedAddressBook] recordForUniqueId:value.uniqueId]];
}

- (void)addGroups:(NSSet *)value {    
    [self willChangeValueForKey:@"groups" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"groups"] unionSet:value];
    [self didChangeValueForKey:@"groups" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    for (SMGroupMO *group in value) {
        [(ABGroup *)mirrorRecord addSubgroup:(ABGroup *)[[ABAddressBook sharedAddressBook] recordForUniqueId:group.uniqueId]];
    }
}

- (void)removeGroups:(NSSet *)value {
    [self willChangeValueForKey:@"groups" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"groups"] minusSet:value];
    [self didChangeValueForKey:@"groups" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    for (SMGroupMO *group in value) {
        [(ABGroup *)mirrorRecord addSubgroup:(ABGroup *)[[ABAddressBook sharedAddressBook] recordForUniqueId:group.uniqueId]];
    }
}

- (void)willSave
{
    NSString *derivedTermName = [NSString stringWithFormat:@"%@%@",SMABTermPrefix,self.termName];
    [mirrorRecord setValue:derivedTermName forProperty:kABGroupNameProperty];
    [super willSave];
}

# pragma mark -
# pragma mark Transient properties

- (NSString *)displayText
{
    return self.termName;
}


@end
