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
 * SMRecordMO                                                                 *
 * StudioMan                                                                  *
 *                                                                            *
 * This class is a subclass of NSManagedObject that implements the abstract   *
 * Record entity. The Record entity is responsible for syncing its changes to *
 * the Address Book when the record is saved or fetched. Each subclass should *
 * call [super awakeFromInsert], [super awakeFromFetch], and [super willSave] *
 * at the end of each of its respective methods.                              *
 *                                                                            *
 ******************************************************************************/

#import "SMRecordMO.h"


@implementation SMRecordMO
@dynamic creationDate;
@dynamic modificationDate;
@dynamic uniqueId;
@dynamic displayText;
@dynamic leaf;

- (void)awakeFromInsert
{
    self.uniqueId = [mirrorRecord valueForProperty:kABUIDProperty];
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

- (BOOL)leaf
{
    return NO;
}

@end
