//
//  SMDetailViewController.h
//  StudioMan
//
//  Created by Nicholas Meyer on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "SMStudioDetailView.h"
#import "SMPersonDetailView.h"

@interface SMDetailViewController : NSViewController {
@private
    
    IBOutlet NSView *superview;
    IBOutlet NSView *displayedView;
    IBOutlet SMStudioDetailView *studioDetailView;
    IBOutlet SMPersonDetailView *personDetailView;
    
    CATransition *transition;
    
}

- (IBAction) selectStudioDetailView:(id)sender;
- (IBAction) selectPersonDetailView:(id)sender;

@end
