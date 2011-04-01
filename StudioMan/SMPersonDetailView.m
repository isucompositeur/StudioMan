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

- (void)awakeFromNib
{
    NSRect cardFrame = NSMakeRect(0, [self bounds].size.height - 48.0, [self bounds].size.width, 48.0);
    cardView = [[SMPersonCardView alloc] initWithFrame:cardFrame];
    [cardView setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin | NSViewWidthSizable | NSViewMinYMargin];
    [self addSubview:cardView];
    
    NSRect calendarFrame = NSMakeRect(0, 0, [self bounds].size.width, [self bounds].size.height - 48.0);
    calendarView = [[SMCalendarView alloc] initWithFrame:calendarFrame];
    [calendarView setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin | NSViewWidthSizable | NSViewHeightSizable | NSViewMinYMargin | NSViewMaxYMargin];
    [self addSubview:calendarView];
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
