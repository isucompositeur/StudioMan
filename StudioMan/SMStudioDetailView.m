//
//  SMStudioDetailView.m
//  StudioMan
//
//  Created by Nicholas Meyer on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SMStudioDetailView.h"


@implementation SMStudioDetailView

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
    [[NSColor redColor] set];
    [NSBezierPath fillRect:[self bounds]];
}

@end
