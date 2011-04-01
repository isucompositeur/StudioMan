//
//  SMDetailViewController.m
//  StudioMan
//
//  Created by Nicholas Meyer on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SMDetailViewController.h"


@implementation SMDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (IBAction)selectPersonDetailView:(id)sender
{
    NSToolbarItem *personDetailItem = (NSToolbarItem *)sender;
    if([[[personDetailItem toolbar] selectedItemIdentifier] isEqualToString:[personDetailItem itemIdentifier]]) {
        NSLog(@"person already selected");
    }
    NSLog(@"person OOOH");
}

- (IBAction)selectStudioDetailView:(id)sender
{
    NSToolbarItem *studioDetailItem = (NSToolbarItem *)sender;
    if([[[studioDetailItem toolbar] selectedItemIdentifier] isEqualToString:[studioDetailItem itemIdentifier]]) {
        NSLog(@"studio already selected");
    }
    NSLog(@"studio AHHHH");
}

@end
