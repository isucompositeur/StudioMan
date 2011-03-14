//
//  SMTermMO.h
//  StudioMan
//
//  Created by Nicholas Meyer on 3/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SMRecordMO.h"

@class SMGroupMO;

@interface SMTermMO : SMRecordMO {
@private
}
@property (nonatomic, retain) NSString* termName;
@property (nonatomic, retain) NSSet* groups;

@end
