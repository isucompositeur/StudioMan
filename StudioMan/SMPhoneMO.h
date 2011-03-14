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
 * SMPhoneMO                                                                  *
 * StudioMan                                                                  *
 *                                                                            *
 * This class is a subclass of SMPropertyMO which handles the Phone entity.   *
 * This entity stores a phone number and its relationship to a person.        *
 *                                                                            *
 ******************************************************************************/

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SMPropertyMO.h"

@class SMPersonMO;

@interface SMPhoneMO : SMPropertyMO {
@private
}
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) SMPersonMO * person;

@end
