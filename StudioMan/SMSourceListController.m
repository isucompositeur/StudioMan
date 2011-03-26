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
static NSString *termManagedObjectKey = @"termManagedObject";

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
}

- (void)updateGroups
{
    [[rootTreeNode mutableChildNodes] removeAllObjects];
    
    NSSet *groups = [termManagedObject valueForKey:SMTermToGroupRelationshipKey];
    
    for (SMGroupMO* group  in groups) {
        [[rootTreeNode mutableChildNodes] addObject:[SMSourceListNode treeNodeWithRepresentedObject:group]];
    }
}

@end
