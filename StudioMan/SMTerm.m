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
#import <Foundation/NSGeometry.h>

static const int SMCalendarControlShowHideSegmentIndex = 1;
static const NSString *SMTermEntity = @"Term";

@implementation SMTerm

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
        collapsedViewRects = [[NSMutableDictionary alloc] init];
    }
    
    NSManagedObject *newTerm = [NSEntityDescription insertNewObjectForEntityForName:SMTermEntity inManagedObjectContext:[self managedObjectContext]];
    [newTerm setValue:@"Untitled term" forKey:@"displayTitle"];
    
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
    //[sidebarSegmentedControl setMenu:addButtonMenu forSegment:0];
}

- (IBAction)clickSideBarControl:(id)sender
{
    NSSegmentedControl *sidebarControl = (NSSegmentedControl *)sender;
    int clickedSegment = [sidebarControl selectedSegment];
    NSPoint point;
    //NSEvent *event;
    
    switch (clickedSegment) {
        case 0:
            point = [sidebarControl convertPoint:[sidebarControl frame].origin fromView:nil];
            NSEvent *event = [NSEvent mouseEventWithType:NSLeftMouseDown location:NSMakePoint(0, 0) modifierFlags:0 timestamp:[NSDate timeIntervalSinceReferenceDate] windowNumber:[[sidebarControl window] windowNumber] context:[[sidebarControl window] graphicsContext] eventNumber:0 clickCount:1 pressure:0];
            [NSMenu popUpContextMenu:addButtonMenu withEvent:event forView:sidebarControl withFont:[NSFont systemFontOfSize:11]];
            break;
        case SMCalendarControlShowHideSegmentIndex:
            NSLog(@"clicked cal icon. Selected: %s",[sidebarControl isSelectedForSegment:clickedSegment] ? "YES" : "NO");
            [sidebarSplitView toggleSubview:helperView];
            if ([sidebarControl isSelectedForSegment:clickedSegment]) {
                [sidebarControl setImage:[NSImage imageNamed:@"Calendars_On"] forSegment:clickedSegment];
                [sidebarControl setSelected:YES forSegment:clickedSegment];
            } else {
                [sidebarControl setImage:[NSImage imageNamed:@"Calendars_Off"] forSegment:clickedSegment];
                [sidebarControl setSelected:NO forSegment:clickedSegment];
            }
            break;
        case 2:
            break;
    }
    
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




@end
