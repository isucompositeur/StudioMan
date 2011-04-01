//
//  SMDetailViewController.m
//  StudioMan
//
//  Created by Nicholas Meyer on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SMDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation SMDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib
{
    displayedView = [self view];
    [studioDetailView setFrame:[superview bounds]];
    [personDetailView setFrame:[superview bounds]];
    
    transition = [CATransition animation];
    [transition setType:kCATransitionFade];
    
    [superview setAnimations:[NSDictionary dictionaryWithObjectsAndKeys:transition, @"subviews", nil]];
    
}

- (void)dealloc
{
    [super dealloc];
}

- (IBAction)selectPersonDetailView:(id)sender
{
    if(displayedView != personDetailView) {
        [[superview animator] replaceSubview:displayedView with:personDetailView];
        displayedView = personDetailView;
    }
}

- (IBAction)selectStudioDetailView:(id)sender
{
    if(displayedView != studioDetailView) {
        [[superview animator] replaceSubview:displayedView with:studioDetailView];
        displayedView = studioDetailView;
    }
    NSLog(@"studio AHHHH");
}

@end
