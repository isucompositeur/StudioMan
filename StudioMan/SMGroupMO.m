/******************************************************************************
 *                                                                            *
 * StudioMan: Music studio management software                                *
 *                                                                            *
 * Copyright (C) 2011 Nicholas Meyer                                          *               
 *                                                                            *
 * This file is part of StudioMan.                                            *
 *                                                                            *
 * StudioMan is free software: you can redistribute it and/or modify it under *
 * the terms of the GNU General Public License as published by the Free       *
 * Software Foundation, either version 3 of the License, or (at your option)  *
 * any later version.                                                         *
 *                                                                            *
 * StudioMan is distributed in the hope that it will be useful, but WITHOUT   *
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or      *
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for  *
 * more details.                                                              *
 *                                                                            *
 * You should have received a copy of the GNU General Public License along    *
 * with StudioMan.  If not, see <http://www.gnu.org/licenses/>.               *
 *                                                                            *
 ******************************************************************************/

/******************************************************************************
 *                                                                            *
 * SMGroupMO                                                                  *
 * StudioMan                                                                  *
 *                                                                            *
 * This class is a subclass of SMRecordMO that handles the user-created       *
 * groups. This class syncs its properties with the Address Book.             *
 *                                                                            *
 ******************************************************************************/

#import "SMGroupMO.h"
#import "SMPersonMO.h"

@implementation SMGroupMO
@dynamic groupName;
@dynamic term;
@dynamic people;
@dynamic isExpanded;

- (void)awakeFromInsert {
    mirrorRecord = [[ABGroup alloc] initWithAddressBook:[ABAddressBook sharedAddressBook]];
    [[ABAddressBook sharedAddressBook] addRecord:mirrorRecord];
    
    [super awakeFromInsert];
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
