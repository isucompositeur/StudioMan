//
//  SMPersonDetailView.m
//  StudioMan
//
//  Created by Nicholas Meyer on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SMPersonDetailView.h"


@implementation SMPersonDetailView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor blueColor] set];
    [NSBezierPath fillRect:[self bounds]];
}

@end
