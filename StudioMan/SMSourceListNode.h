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
 * SMSourceListNode                                                           *
 * StudioMan                                                                  *
 *                                                                            *
 * This class is a subclass of NSTreeNode. Each instance acts as a proxy for  *
 * an object in the data store; valueForUndefinedKey methods are overridden   *
 * in order to forward these requests to the underlying object.               *
 *                                                                            *
 ******************************************************************************/

#import <Foundation/Foundation.h>


@interface SMSourceListNode : NSTreeNode {
@private
    
}

@property (nonatomic, assign) BOOL isExpanded;

@end
