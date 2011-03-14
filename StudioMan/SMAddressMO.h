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
 * SMAddressMO                                                                *
 * StudioMan                                                                  *
 *                                                                            *
 * This class is a subclass of SMPropertyMO which handles the Address entity. *
 * This entity holds the components of an address and its relationship to a   *
 * person.                                                                    *
 *                                                                            *
 ******************************************************************************/

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SMPropertyMO.h"

@class SMPersonMO;

@interface SMAddressMO : SMPropertyMO {
@private
}
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) SMPersonMO * person;

@end
