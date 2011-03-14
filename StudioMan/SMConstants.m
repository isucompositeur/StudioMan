//
//  SMConstants.m
//  StudioMan
//
//  Created by Nicholas Meyer on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SMConstants.h"

NSString * const SMTermEntity = @"Term";
NSString * const SMRecordEntity = @"Record";
NSString * const SMGroupEntity = @"Group";
NSString * const SMPersonEntity = @"Person";
NSString * const SMPropertyEntity = @"Property";
NSString * const SMEmailEntity = @"Email";
NSString * const SMAddressEntity = @"Address";
NSString * const SMPhoneEntity = @"Phone";

NSString * const SMTermToGroupRelationshipKey = @"groups";
NSString * const SMGroupToTermRelationshipKey = @"term";
NSString * const SMGroupToPersonRelationshipKey = @"people";
NSString * const SMPersonToGroupRelationshipKey = @"group";
NSString * const SMPropertyToPersonRelationshipKey = @"person";
NSString * const SMPersonToEmailRelationshipKey = @"emails";
NSString * const SMPersonToAddressRelationshipKey = @"addresses";
NSString * const SMPersonToPhoneRelationshipKey = @"phones";

NSString * const SMRecordUniqueIDKey = @"uniqueId";
NSString * const SMRecordCreationDateKey = @"creationDate";
NSString * const SMRecordModificationDateKey = @"modificationDate";

NSString * const SMTermNameKey = @"termName";
NSString * const SMTermStartDateKey = @"startDate";
NSString * const SMTermEndDateKey = @"endDate";

NSString * const SMGroupNameKey = @"groupName";
