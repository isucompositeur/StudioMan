//
//  SMSourceListController.h
//  StudioMan
//
//  Created by Nicholas Meyer on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

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
@property (readonly, nonatomic) id arrangedObjects;

- (void)updateGroups;
- (void)updatePeopleForGroup:(SMSourceListNode *)group;
- (id)arrangedObjects;

@end

