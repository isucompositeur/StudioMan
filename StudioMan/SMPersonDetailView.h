//
//  SMPersonDetailView.h
//  StudioMan
//
//  Created by Nicholas Meyer on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SMPersonCardView.h"
#import "SMCalendarView.h"

@interface SMPersonDetailView : NSView {
@private
    SMPersonCardView *cardView;
    SMCalendarView *calendarView;
}

@end
