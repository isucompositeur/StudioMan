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

- (void)awakeFromNib
{
    
}
- (void)drawRect:(NSRect)dirtyRect
{
    NSColor *topColor;
    if([[self window] isKeyWindow]) {
        topColor = [NSColor colorWithCalibratedRed:(214.0/256.0) green:(221.0/256.0) blue:(229.0/256.0) alpha:1.0];
    } else {
        topColor = [NSColor colorWithCalibratedWhite:(238.0/256.0) alpha:1.0];
    }
    
    //NSGradient *backgroundGradient = [[NSGradient alloc] initWithStartingColor:topColor endingColor:[NSColor lightGrayColor]];
    
    NSGradient *backgroundGradient = [[NSGradient alloc] initWithColorsAndLocations:
                                      topColor ,0.0,
                                      [NSColor whiteColor], 0.618033988749895, 
                                      [NSColor colorWithCalibratedWhite:(15.0/16.0) alpha:1.0], 0.854101966249685, 
                                      [NSColor colorWithCalibratedWhite:(7.0/8.0) alpha:1.0], 0.944271909999159, nil];
    
    [backgroundGradient drawInRect:[self bounds] angle:270.0];
}

@end
