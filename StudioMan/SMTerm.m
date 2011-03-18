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
 * SMTerm                                                                     *
 * StudioMan                                                                  *
 *                                                                            *
 * This class is a subclass of NSPersistentDocument that acts as the          *
 * document class for StudioMan. It is the delegate for the toolbar and       *
 * split views that make up part of the interface.                            *
 *                                                                            *
 ******************************************************************************/

#import "SMTerm.h"
#import "AmberKit/AmberKit.h"
#import <Foundation/NSGeometry.h>
#import "SMGroupMO.h"
#import "SMPersonMO.h"

static const NSUInteger SMCalendarControlAddSegmentIndex = 0;
static const NSUInteger SMCalendarControlShowHideSegmentIndex = 1;
static const NSTimeInterval SMCalendarControlAnimationDuration = 0.2;

@implementation SMTerm
@synthesize calendarControl;

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
        collapsedViewRects = [[NSMutableDictionary alloc] init];
    }
    
    rootTermObject = [NSEntityDescription insertNewObjectForEntityForName:SMTermEntity inManagedObjectContext:[self managedObjectContext]];
    [rootTermObject setValue:@"Untitled term" forKey:SMTermNameKey];
    
    //temporary placeholders until new term sheet is implemented
    [rootTermObject setValue:[NSDate date] forKey:SMTermStartDateKey];
    [rootTermObject setValue:[NSDate date] forKey:SMTermEndDateKey];
    
    NSManagedObject *newGroup = [NSEntityDescription insertNewObjectForEntityForName:SMGroupEntity inManagedObjectContext:[self managedObjectContext]];
    [newGroup setValue:@"Students" forKey:SMGroupNameKey];
    [newGroup setValue:rootTermObject forKey:SMGroupToTermRelationshipKey];
    calendarIsActive = YES;
    
    return self;
}

- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"SMTerm";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    [sidebarSegmentedControl setMenu:addButtonMenu forSegment:SMCalendarControlAddSegmentIndex];
}

- (void)awakeFromNib
{
    
}

- (IBAction)clickSideBarControl:(id)sender
{
    NSSegmentedControl *sidebarControl = (NSSegmentedControl *)sender;
    int clickedSegment = [sidebarControl selectedSegment];
    //NSEvent *event;
    
    switch (clickedSegment) {
        case 0:
            [sourceListTreeController addChild:sidebarControl];
            //NSLog(@"%@",[rootTermObject valueForKey:@"groups"]);
            
            id selectedObject = [[sourceListTreeController selectedObjects] objectAtIndex:0];
            if ([selectedObject isKindOfClass:[SMGroupMO class]]) {
                NSLog(@"is a group");
                [sourceListTreeController addChild:sidebarControl];
            } else if([selectedObject isKindOfClass:[SMPersonMO class]]) {
                NSLog(@"is a person");
                [sourceListTreeController insert:sidebarControl];
            } else {}
            
            break;
        case SMCalendarControlShowHideSegmentIndex:
            NSLog(@"clicked cal icon. Selected: %s",[sidebarControl isSelectedForSegment:clickedSegment] ? "YES" : "NO");
            if (!isAnimating) {
                [sidebarSplitView toggleSubview:helperView withDuration:SMCalendarControlAnimationDuration];
                //This is crude, but necessary until I implement a proper CAAnimation for this.
                isAnimating = YES; 
                [self performSelector:@selector(animationDidEnd) withObject:nil afterDelay:SMCalendarControlAnimationDuration];
                if (calendarIsActive) {
                    [sidebarControl setImage:[NSImage imageNamed:@"Calendars_Off"] forSegment:clickedSegment];
                    calendarIsActive = NO;
                } else {
                    [sidebarControl setImage:[NSImage imageNamed:@"Calendars_On"] forSegment:clickedSegment];
                    calendarIsActive = YES;
                }
            }
            break;
        case 2:
            break;
    }
    
}

- (void)animationDidEnd {
    isAnimating = NO;
}

- (BOOL)itemIsGroup:(id)item {
    return [[[(NSManagedObject *)[item representedObject] entity] name] isEqualToString:SMGroupEntity];
}

# pragma mark -
# pragma mark NSSplitViewDelegate methods

- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)subview {
    if(subview == helperView || subview == [sidebarSplitView superview]) {
        return NO;
    } else {
        return YES;
    }
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(NSInteger)dividerIndex {
    if(splitView == mainSplitView) {
        return 180.0;
    } else if (splitView == sidebarSplitView) {
        return [splitView frame].size.height - (180.0 + [splitView dividerThickness]);
    } else {
        return proposedMin;
    }
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(NSInteger)dividerIndex {
    if(splitView == mainSplitView) {
        return [splitView frame].size.width / 2.0;
    } else if(splitView == sidebarSplitView) {
        return [splitView frame].size.height - (180.0 + [splitView dividerThickness]);
    } else {
        return proposedMax;
    }
}

- (BOOL)splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex
{
    return YES;
}


# pragma mark -
# pragma mark NSSplitViewDelegateAdditions methods

- (void)setOriginalRect:(NSRect)rect forSubview:(NSView *)subview
{
    [collapsedViewRects setValue:NSStringFromRect(rect) forKey:[subview description]];
}

- (NSRect)originalRectForSubview:(NSView *)subview
{
    NSString *rectString = [collapsedViewRects valueForKey:[subview description]];
    return NSRectFromString(rectString);
}

# pragma mark -
# pragma mark NSOutlineViewDelegate methods

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    if([self itemIsGroup:item]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)outlineView:(NSOutlineView *)sender willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    if([self itemIsGroup:item]) {
        NSMutableAttributedString *newTitle = [[cell attributedStringValue] mutableCopy];
        [newTitle replaceCharactersInRange:NSMakeRange(0,[newTitle length]) withString:[[newTitle string] uppercaseString]];
        [cell setAttributedStringValue:newTitle];
        [newTitle release];
    }
}
# pragma mark -
# pragma mark NSToolbarDelegate methods


@end
