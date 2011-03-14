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

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SMRecordMO.h"

@class SMGroupMO;

@interface SMTermMO : SMRecordMO {
@private
}
@property (nonatomic, retain) NSString* termName;
@property (nonatomic, retain) NSSet* groups;
@property (nonatomic, retain) NSDate* startDate;
@property (nonatomic, retain) NSDate* endDate;

@end
