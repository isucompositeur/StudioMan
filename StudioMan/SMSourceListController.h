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
 * SMSourceListController                                                     *
 * StudioMan                                                                  *
 *                                                                            *
 * This class is a subclass of NSController that acts as the data source and  *
 * delegate for the source list as well as handling insertion and removal of  *
 * objects.                                                                   *
 *                                                                            *
 ******************************************************************************/

#import <Cocoa/Cocoa.h>

extern NSString * const SMFilterValueKey;

@class SMTermMO, SMSourceListNode;

@interface SMSourceListController : NSController <NSOutlineViewDelegate, NSOutlineViewDataSource> {
@private
    
    SMTermMO *termManagedObject;
    NSManagedObjectContext *managedObjectContext;
    
    NSString *filterValue;
    
    SMSourceListNode *rootTreeNode;
    
    IBOutlet NSOutlineView *sourceListView;
    
}

@property (retain, nonatomic) SMTermMO *termManagedObject;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) NSString *filterValue;

- (IBAction)addPerson:(id)sender;
- (IBAction)addGroup:(id)sender;

@end

