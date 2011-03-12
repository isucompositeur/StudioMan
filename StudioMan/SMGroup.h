//
//  Group.h
//  StudioMan
//
//  Created by Nicholas Meyer on 3/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SMRecord.h"


@interface SMGroup : SMRecord {
@private
}
@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSManagedObject * term;
@property (nonatomic, retain) NSSet* people;

@end
