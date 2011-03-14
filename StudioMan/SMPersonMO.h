//
//  SMPersonMO.h
//  StudioMan
//
//  Created by Nicholas Meyer on 3/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SMRecordMO.h"

@class SMAddressMO, SMEmailMO, SMGroupMO, SMPhoneMO;

@interface SMPersonMO : SMRecordMO {
@private
}
@property (nonatomic, retain) id people;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSSet* emails;
@property (nonatomic, retain) NSSet* phones;
@property (nonatomic, retain) NSSet* addresses;
@property (nonatomic, retain) SMGroupMO * group;

@end
