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

#import <Cocoa/Cocoa.h>
#import "NSSplitView+Additions.h"

@interface SMTerm : NSPersistentDocument <NSSplitViewDelegate, NSSplitViewDelegateAdditions> {
    
    IBOutlet NSWindow *window; // temp until XCode4 is fixed
    
    IBOutlet NSSplitView *mainSplitView;
    IBOutlet NSSplitView *sidebarSplitView;
    
    IBOutlet NSView *sourceView;
    IBOutlet NSView *helperView;
    IBOutlet NSView *mainView;
    
    NSMutableDictionary *collapsedViewRects;

}

- (IBAction)clickSideBarControl:(id)sender;

@end
