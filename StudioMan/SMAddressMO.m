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

#import "SMAddressMO.h"
#import "SMPersonMO.h"


@implementation SMAddressMO
@dynamic state;
@dynamic street;
@dynamic city;
@dynamic zip;
@dynamic person;

- (NSString *) displayText
{
    return [NSString stringWithFormat:@"%@\n%@, %@ %@",self.street, self.city,
            self.state, self.zip];
}

@end
