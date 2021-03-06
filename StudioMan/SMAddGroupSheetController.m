//
//  SMAddGroupSheetController.m
//  StudioMan
//
//  Created by Nicholas Meyer on 3/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SMAddGroupSheetController.h"
#import "SMTerm.h"
#import "SMGroupMO.h"
#import "SMConstants.h"
#import "SMSourceListController.h"


@implementation SMAddGroupSheetController

@synthesize termWindow, newGroupSheet, sourceListController, newGroupController;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(termWindowWillClose:)
                                                 name:NSWindowWillCloseNotification
                                               object:termWindow];
}

- (void)termWindowWillClose:(NSNotification *)note {
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:nil object:nil];
    [newGroupSheet autorelease];
    [newGroupController autorelease];
}

- (NSManagedObjectContext *)documentManagedObjectContext
{
    return [term managedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext == nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:
         [[self documentManagedObjectContext] persistentStoreCoordinator]];
    }
    
    return managedObjectContext;
    
}

- (IBAction)add:sender {
    
    if (newGroupSheet == nil) {
        NSBundle *myBundle = [NSBundle bundleForClass:[self class]];
        NSNib *nib = [[NSNib alloc] initWithNibNamed:@"SMAddGroupSheet" bundle:myBundle];
        BOOL success = [nib instantiateNibWithOwner:self topLevelObjects:nil];
        
        if (success != YES) {
            // should present error
            return;
        }
    }
    
    NSUndoManager *undoManager = [[self managedObjectContext] undoManager];
    [undoManager disableUndoRegistration];
    
    id newObject = [newGroupController newObject];
    [newGroupController addObject:newObject];
    
    [[self managedObjectContext] processPendingChanges];
    [undoManager enableUndoRegistration];
    
    [NSApp beginSheet:newGroupSheet
       modalForWindow:termWindow
        modalDelegate:self
       didEndSelector:@selector(newGroupSheetDidEnd:returnCode:contextInfo:)
          contextInfo:NULL];
}

- (IBAction)completeAddGroup:sender {
    [newGroupController commitEditing];
    [NSApp endSheet:newGroupSheet returnCode:NSOKButton];
}

- (IBAction)cancelAddGroup:sender {
    [NSApp endSheet:newGroupSheet returnCode:NSCancelButton];
}

- (void)newGroupSheetDidEnd:(NSWindow *)sheet
                  returnCode:(int)returnCode
                 contextInfo:(void  *)contextInfo {
    
    SMGroupMO *sheetObject = [newGroupController content];
    
    if (returnCode == NSOKButton) {
        SMGroupMO *newGroup = [NSEntityDescription insertNewObjectForEntityForName:SMGroupEntity inManagedObjectContext:self.documentManagedObjectContext];
        NSArray *keys = [[NSEntityDescription entityForName:SMGroupEntity inManagedObjectContext:self.managedObjectContext] attributeKeys];
        NSDictionary *values = [sheetObject dictionaryWithValuesForKeys:keys];
        [newGroup setValuesForKeysWithDictionary:values];
        [newGroup setValue:term.rootTermObject forKey:SMGroupToTermRelationshipKey];
        [sourceListController insertGroup:newGroup];
    }
    
    [newGroupController setContent:nil];
    [[self managedObjectContext] reset];
    
    [newGroupSheet orderOut:self];
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)sender {
    return [[self managedObjectContext] undoManager];
}

- (IBAction)undo:sender {
    [[[self managedObjectContext] undoManager] undo];
}

- (IBAction)redo:sender {
    [[[self managedObjectContext] undoManager] redo];
}

- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem {
    if ([anItem action] == @selector(undo:)) {
        return [[[self managedObjectContext] undoManager] canUndo];
    }
    if ([anItem action] == @selector(redo:)) {
        return [[[self managedObjectContext] undoManager] canRedo];
    }
    return YES;
}

- (void)dealloc
{
    [super dealloc];
}

@end
