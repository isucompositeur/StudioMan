//
//  SMSourceListController.m
//  StudioMan
//
//  Created by Nicholas Meyer on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(context == &SMGroupChangeContext) {
        [self updateGroups];
    }
    
    for (SMSourceListNode *node in [rootTreeNode childNodes]) {
        NSLog(@"%@",[node valueForKey:@"displayText"]);
    }
    //NSLog(@"%@",[rootTreeNode childNodes]);
}

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
    if([item parentNode] == rootTreeNode) {
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
    if([item parentNode] == nil) {
        return YES;
    } else {
        return NO;
    }
}

- (void)outlineView:(NSOutlineView *)sender willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item {
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
    [self updateGroups];
    [sourceListView reloadData];
}

- (void)setFilterValue:(NSString *)value
{
    [self willChangeValueForKey:SMFilterValueKey];
    filterValue = value;
    [self didChangeValueForKey:SMFilterValueKey];
}

- (void)updateGroups
{
    for (SMSourceListNode *groupNode in [rootTreeNode childNodes]) {
        [[groupNode representedObject] removeObserver:self forKeyPath:SMGroupToPersonRelationshipKey];
    }
    
    [[rootTreeNode mutableChildNodes] removeAllObjects];
    
    NSSet *groups = [termManagedObject valueForKey:SMTermToGroupRelationshipKey];
    
    for (SMGroupMO* group  in groups) {
        SMSourceListNode *newGroup = [SMSourceListNode treeNodeWithRepresentedObject:group];
        [[rootTreeNode mutableChildNodes] addObject:newGroup];
        [group addObserver:self forKeyPath:SMGroupToPersonRelationshipKey options:0 context:&SMPersonChangeContext];
        
        [self updatePeopleForGroup:newGroup];
    }
}

- (void)updatePeopleForGroup:(SMSourceListNode *)group
{
    [[group mutableChildNodes] removeAllObjects];
    NSSet *people = [[group representedObject] valueForKey:SMGroupToPersonRelationshipKey];
    
    for (SMPersonMO *person in people) {
        SMSourceListNode *newPerson = [SMSourceListNode treeNodeWithRepresentedObject:person];
        [[group mutableChildNodes] addObject:newPerson];
    }
}

- (id)arrangedObjects
{
    return rootTreeNode;
}

@end
