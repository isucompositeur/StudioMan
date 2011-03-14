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
 * SMTermMO                                                                   *
 * StudioMan                                                                  *
 *                                                                            *
 * This class is a subclass of SMRecordMO that handles the root term object   *
 * for each term. The term is synchronized with a root level group in the     *
 * shared address book and all groups within the term are subgroups of this   *
 * root level group. In addition, the term managed object syncs with the      *
 * calendar store to manage this term's calendar.                             *
 *                                                                            *
 ******************************************************************************/

#import "SMTermMO.h"
#import "SMGroupMO.h"

NSString * const SMABTermPrefix = @"StudioMan - ";

@implementation SMTermMO
@dynamic termName;
@dynamic groups;
@dynamic startDate;
@dynamic endDate;

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
