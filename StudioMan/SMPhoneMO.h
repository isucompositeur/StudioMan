//
//  SMPhoneMO.h
//  StudioMan
//
//  Created by Nicholas Meyer on 3/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SMPropertyMO.h"

@class SMPersonMO;

@interface SMPhoneMO : SMPropertyMO {
@private
}
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) SMPersonMO * person;

@end
