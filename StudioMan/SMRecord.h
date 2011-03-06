//
//  Record.h
//  StudioMan
//
//  Created by Nicholas Meyer on 3/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SMRecord : NSManagedObject {
@private
}
@property (nonatomic, retain) UNKNOWN_TYPE uniqueId;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSDate * modificationDate;
@property (nonatomic, retain) UNKNOWN_TYPE displayText;

@end
