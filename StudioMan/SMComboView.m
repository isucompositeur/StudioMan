//
//  SMComboView.m
//  StudioMan
//
//  Created by Nicholas Meyer on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SMComboView.h"


@implementation SMComboView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self addSubview:personCard];
    [personCard setFrame:NSMakeRect(0, [self bounds].size.height - 48, [self bounds].size.width, 48.0)];
}

- (void)dealloc
{
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

@end
