//
//  SMComboView.h
//  StudioMan
//
//  Created by Nicholas Meyer on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SMPersonCardView.h"

@interface SMComboView : NSView {
@private
    
    IBOutlet SMPersonCardView *personCard;
    
}

@end
