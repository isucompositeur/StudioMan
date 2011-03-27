//
//  SMPersonCard.m
//  StudioMan
//
//  Created by Nicholas Meyer on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SMPersonCardView.h"


@implementation SMPersonCardView

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
    NSColor *topColor = [NSColor colorWithCalibratedRed:(214.0/256.0) green:(221.0/256.0) blue:(229.0/256.0) alpha:1.0];
    NSGradient *backgroundGradient = [[NSGradient alloc] initWithStartingColor:topColor endingColor:[NSColor whiteColor]];
    
    [backgroundGradient drawInRect:[self bounds] angle:270.0];
}

@end
