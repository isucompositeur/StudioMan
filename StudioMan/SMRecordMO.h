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

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <AddressBook/AddressBook.h>


@interface SMRecordMO : NSManagedObject {
@protected
    ABRecord *mirrorRecord;
@private
    
}
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSDate * modificationDate;
@property (nonatomic, retain) NSString * uniqueId;
@property (nonatomic, retain) NSString * displayText;

@end
