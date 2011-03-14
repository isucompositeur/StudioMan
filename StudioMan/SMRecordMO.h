//
//  SMRecordMO.h
//  StudioMan
//
//  Created by Nicholas Meyer on 3/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <AddressBook/AddressBook.h>


@interface SMRecordMO : NSManagedObject {
@protected
    ABRecord *mirrorRecord;
@private
    
}
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSDate * modificationDate;
@property (nonatomic, retain) NSString * uniqueId;
@property (nonatomic, retain) NSString * displayText;

@end
