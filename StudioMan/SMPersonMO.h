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

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SMRecordMO.h"

@class SMAddressMO, SMEmailMO, SMGroupMO, SMPhoneMO;

@interface SMPersonMO : SMRecordMO {
@private
}
@property (nonatomic, retain) NSSet* people;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSSet* emails;
@property (nonatomic, retain) NSSet* phones;
@property (nonatomic, retain) NSSet* addresses;
@property (nonatomic, retain) SMGroupMO * group;

@end
