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

#import "SMSourceListController.h"
#import "SMTermMO.h"
#import "SMGroupMO.h"
#import "SMPersonMO.h"
#import "SMSourceListNode.h"
#import "SMConstants.h"

static int SMGroupChangeContext = 520932930;
static int SMPersonChangeContext = 28925691;


static NSString *termManagedObjectKey = @"termManagedObject";

NSString * const SMFilterValueKey = @"filterValue";

@implementation SMSourceListController

@synthesize managedObjectContext;
@synthesize filterValue;
@synthesize termManagedObject;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    self.managedObjectContext = nil;
    self.termManagedObject = nil;
    
    [rootTreeNode release];    
    [super dealloc];
}

# pragma mark -
# pragma mark NSKeyValueObserving methods

/*- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(context == &SMGroupChangeContext) {
        [self updateGroups];
    }
    
    if(context == &SMPersonChangeContext) {
        [self updateGroups];
    }
    
    for (SMSourceListNode *node in [rootTreeNode childNodes]) {
        NSLog(@"%@",[node valueForKey:@"displayText"]);
    }
    //NSLog(@"%@",[rootTreeNode childNodes]);
}*/

# pragma mark -
# pragma mark NSOutlineViewDataSource methods

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil) {
        return [[rootTreeNode childNodes] objectAtIndex:index];
    } else {
        return [[item childNodes] objectAtIndex:index];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if([item parentNode] == rootTreeNode && [[item childNodes] count] > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [[rootTreeNode childNodes] count];
    } else {
        return [[item childNodes] count];
    }
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    return [[item representedObject] displayText];
}

# pragma mark -
# pragma mark NSOutlineViewDelegate methods

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    if([item parentNode] == rootTreeNode) {
        return YES;
    } else {
        return NO;
    }
}

- (void)outlineView:(NSOutlineView *)sender willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item 
{
    if([item parentNode] == rootTreeNode) {
        NSMutableAttributedString *newTitle = [[cell attributedStringValue] mutableCopy];
        [newTitle replaceCharactersInRange:NSMakeRange(0,[newTitle length]) withString:[[newTitle string] uppercaseString]];
        [cell setAttributedStringValue:newTitle];
        [newTitle release];
    }
}

# pragma mark -
# pragma mark Custom logic

- (void)setTermManagedObject:(SMTermMO *)term
{
    [self willChangeValueForKey:termManagedObjectKey];
    
    SMTermMO *oldTermManagedObject = termManagedObject;
    termManagedObject = term;
    
    
    if(oldTermManagedObject != nil) {
        [termManagedObject removeObserver:self forKeyPath:SMTermToGroupRelationshipKey];
        [oldTermManagedObject release];
    }
    
    if(termManagedObject != nil) {
        [termManagedObject addObserver:self forKeyPath:SMTermToGroupRelationshipKey options:0 context:&SMGroupChangeContext];
        [termManagedObject retain];
    }
    
    SMSourceListNode *oldRootTreeNode = rootTreeNode;
    rootTreeNode = [[SMSourceListNode alloc] initWithRepresentedObject:termManagedObject];
    if (oldRootTreeNode != nil) {
        [oldRootTreeNode release];
    }
    
    [self didChangeValueForKey:termManagedObjectKey];
    
    for (SMSourceListNode *groupNode in [rootTreeNode childNodes]) {
        [[groupNode representedObject] removeObserver:self forKeyPath:SMGroupToPersonRelationshipKey];
    }
    
    [[rootTreeNode mutableChildNodes] removeAllObjects];
    
    NSSet *groups = [termManagedObject valueForKey:SMTermToGroupRelationshipKey];
    
    for (SMGroupMO* group  in groups) {
        SMSourceListNode *newGroup = [SMSourceListNode treeNodeWithRepresentedObject:group];
        [[rootTreeNode mutableChildNodes] addObject:newGroup];
        [group addObserver:self forKeyPath:SMGroupToPersonRelationshipKey options:0 context:&SMPersonChangeContext];
        
        [[newGroup mutableChildNodes] removeAllObjects];
        NSSet *people = [[newGroup representedObject] valueForKey:SMGroupToPersonRelationshipKey];
        
        for (SMPersonMO *person in people) {
            SMSourceListNode *newPerson = [SMSourceListNode treeNodeWithRepresentedObject:person];
            [[newGroup mutableChildNodes] addObject:newPerson];
        }
    }
    
    [sourceListView reloadData];
}

- (void)setFilterValue:(NSString *)value
{
    [self willChangeValueForKey:SMFilterValueKey];
    filterValue = value;
    [self didChangeValueForKey:SMFilterValueKey];
}

- (IBAction)addGroup:(id)sender
{
    SMGroupMO *newGroup = [NSEntityDescription insertNewObjectForEntityForName:SMGroupEntity inManagedObjectContext:self.managedObjectContext];
    [newGroup setValue:@"New group" forKey:SMGroupNameKey];
    [newGroup setValue:termManagedObject forKey:SMGroupToTermRelationshipKey];
    
    SMSourceListNode *newGroupNode = [SMSourceListNode treeNodeWithRepresentedObject:newGroup];
    [[rootTreeNode mutableChildNodes] addObject:newGroupNode];
    
    [sourceListView reloadData];
    NSIndexSet *newSelectionIndex = [NSIndexSet indexSetWithIndex:[sourceListView rowForItem:newGroupNode]];
    [sourceListView selectRowIndexes:newSelectionIndex byExtendingSelection:NO];
    
}

- (IBAction)addPerson:(id)sender
{
    SMSourceListNode *selectedNode = [sourceListView itemAtRow:[sourceListView selectedRow]];
    NSTreeNode *parentNode;
    
    if([[selectedNode representedObject] entity] == [NSEntityDescription entityForName:SMPersonEntity inManagedObjectContext:self.managedObjectContext]) {
        parentNode = [selectedNode parentNode];
    } else {
        parentNode = selectedNode;
    }
    
    SMPersonMO *newPerson = [NSEntityDescription insertNewObjectForEntityForName:SMPersonEntity inManagedObjectContext:self.managedObjectContext];
    [newPerson setValue:@"Jamie" forKey:SMFirstNameKey];
    [newPerson setValue:@"Doebuck" forKey:SMLastNameKey];
    [newPerson setValue:[parentNode representedObject] forKey:SMPersonToGroupRelationshipKey];
    
    SMSourceListNode *newPersonNode = [SMSourceListNode treeNodeWithRepresentedObject:newPerson];
    [[parentNode mutableChildNodes] addObject:newPersonNode];
    
    [sourceListView reloadData];
    [sourceListView expandItem:parentNode];
    NSIndexSet *newSelectionIndex = [NSIndexSet indexSetWithIndex:[sourceListView rowForItem:newPersonNode]];
    [sourceListView selectRowIndexes:newSelectionIndex byExtendingSelection:NO];
}

@end
