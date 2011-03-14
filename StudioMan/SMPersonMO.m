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
 * SMPersonMO                                                                 *
 * StudioMan                                                                  *
 *                                                                            *
 * This class is a subclass of SMRecordMO that keeps data for each person     *
 * being tracked for the term. It has properties that correspond to and       *
 * synchronize with the address book, as well as additional information not   *
 * appropriate to the address book that is used by the program.               *
 *                                                                            *
 ******************************************************************************/

#import "SMPersonMO.h"
#import "SMAddressMO.h"
#import "SMEmailMO.h"
#import "SMGroupMO.h"
#import "SMPhoneMO.h"


@implementation SMPersonMO
@dynamic people;
@dynamic firstName;
@dynamic note;
@dynamic birthday;
@dynamic lastName;
@dynamic emails;
@dynamic phones;
@dynamic addresses;
@dynamic group;

- (void)addEmailsObject:(SMEmailMO *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"emails" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"emails"] addObject:value];
    [self didChangeValueForKey:@"emails" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeEmailsObject:(SMEmailMO *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"emails" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"emails"] removeObject:value];
    [self didChangeValueForKey:@"emails" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addEmails:(NSSet *)value {    
    [self willChangeValueForKey:@"emails" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"emails"] unionSet:value];
    [self didChangeValueForKey:@"emails" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeEmails:(NSSet *)value {
    [self willChangeValueForKey:@"emails" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"emails"] minusSet:value];
    [self didChangeValueForKey:@"emails" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addPhonesObject:(SMPhoneMO *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"phones" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"phones"] addObject:value];
    [self didChangeValueForKey:@"phones" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removePhonesObject:(SMPhoneMO *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"phones" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"phones"] removeObject:value];
    [self didChangeValueForKey:@"phones" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addPhones:(NSSet *)value {    
    [self willChangeValueForKey:@"phones" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"phones"] unionSet:value];
    [self didChangeValueForKey:@"phones" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removePhones:(NSSet *)value {
    [self willChangeValueForKey:@"phones" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"phones"] minusSet:value];
    [self didChangeValueForKey:@"phones" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addAddressesObject:(SMAddressMO *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"addresses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"addresses"] addObject:value];
    [self didChangeValueForKey:@"addresses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeAddressesObject:(SMAddressMO *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"addresses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"addresses"] removeObject:value];
    [self didChangeValueForKey:@"addresses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addAddresses:(NSSet *)value {    
    [self willChangeValueForKey:@"addresses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"addresses"] unionSet:value];
    [self didChangeValueForKey:@"addresses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeAddresses:(NSSet *)value {
    [self willChangeValueForKey:@"addresses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"addresses"] minusSet:value];
    [self didChangeValueForKey:@"addresses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}



@end
