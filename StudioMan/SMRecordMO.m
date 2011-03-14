//
//  SMRecordMO.m
//  StudioMan
//
//  Created by Nicholas Meyer on 3/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SMRecordMO.h"


@implementation SMRecordMO
@dynamic creationDate;
@dynamic modificationDate;
@dynamic uniqueId;
@dynamic displayText;

- (void)awakeFromInsert
{
    mirrorRecord = [[ABAddressBook sharedAddressBook] recordForUniqueId:self.uniqueId];
    self.creationDate = [mirrorRecord valueForProperty:kABCreationDateProperty];
}

- (void)awakeFromFetch
{
    mirrorRecord = [[ABAddressBook sharedAddressBook] recordForUniqueId:self.uniqueId];
}

- (void)willSave
{
    [[ABAddressBook sharedAddressBook] save];
    self.modificationDate = [mirrorRecord valueForProperty:kABModificationDateProperty];
}

@end
