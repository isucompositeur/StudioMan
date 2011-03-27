//
//  SMAddGroupSheetController.h
//  StudioMan
//
//  Created by Nicholas Meyer on 3/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SMTerm, SMSourceListController;

@interface SMAddGroupSheetController : NSObject {
@private
    
    IBOutlet NSWindow *termWindow;
    IBOutlet NSObjectController *newGroupController;
    IBOutlet NSPanel *newGroupSheet;
    IBOutlet NSManagedObjectContext *managedObjectContext;
    IBOutlet SMTerm *term;
    IBOutlet SMSourceListController *sourceListController;
    
}

@property (nonatomic, retain) NSWindow *termWindow;
@property (nonatomic, retain) NSObjectController *newGroupController;
@property (nonatomic, retain) NSPanel *newGroupSheet;
@property (nonatomic, retain) SMSourceListController *sourceListController;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectContext *documentManagedObjectContext;

- (IBAction)add:(id)sender;

- (IBAction)completeAddGroup:sender;
- (IBAction)cancelAddGroup:sender;

- (IBAction)undo:sender;
- (IBAction)redo:sender;

@end
