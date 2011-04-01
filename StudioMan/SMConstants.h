/******************************************************************************
 *                                                                            *
 * StudioMan: Music studio management software                                *
 *                                                                            *
 * Copyright (C) 2011 Nicholas Meyer                                          *               
 *                                                                            *
 * This file is part of StudioMan.                                            *
 *                                                                            *
 * StudioMan is free software: you can redistribute it and/or modify it under *
 * the terms of the GNU General Public License as published by the Free       *
 * Software Foundation, either version 3 of the License, or (at your option)  *
 * any later version.                                                         *
 *                                                                            *
 * StudioMan is distributed in the hope that it will be useful, but WITHOUT   *
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or      *
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for  *
 * more details.                                                              *
 *                                                                            *
 * You should have received a copy of the GNU General Public License along    *
 * with StudioMan.  If not, see <http://www.gnu.org/licenses/>.               *
 *                                                                            *
 ******************************************************************************/

/******************************************************************************
 *                                                                            *
 * SMConstants                                                                *
 * StudioMan                                                                  *
 *                                                                            *
 * These files define program-wide constants for commonly-used keys and       *
 * properties.                                                                *
 *                                                                            *
 ******************************************************************************/
#import <Cocoa/Cocoa.h>

extern NSString * const SMTermEntity;
extern NSString * const SMRecordEntity;
extern NSString * const SMGroupEntity;
extern NSString * const SMPersonEntity;
extern NSString * const SMPropertyEntity;
extern NSString * const SMEmailEntity;
extern NSString * const SMAddressEntity;
extern NSString * const SMPhoneEntity;

extern NSString * const SMTermToGroupRelationshipKey;
extern NSString * const SMGroupToTermRelationshipKey;
extern NSString * const SMGroupToPersonRelationshipKey;
extern NSString * const SMPersonToGroupRelationshipKey;
extern NSString * const SMPropertyToPersonRelationshipKey;
extern NSString * const SMPersonToEmailRelationshipKey;
extern NSString * const SMPersonToAddressRelationshipKey;
extern NSString * const SMPersonToPhoneRelationshipKey;

extern NSString * const SMPersonSearchToolbarItemIdentifier;

extern NSString * const SMDisplayTextKey;

extern NSString * const SMRecordUniqueIDKey;
extern NSString * const SMRecordCreationDateKey;
extern NSString * const SMRecordModificationDateKey;

extern NSString * const SMTermNameKey;
extern NSString * const SMTermStartDateKey;
extern NSString * const SMTermEndDateKey;

extern NSString * const SMGroupNameKey;

extern NSString * const SMFirstNameKey;
extern NSString * const SMLastNameKey;
extern NSString * const SMNoteKey;

extern NSString * const kSMStudioDetailView;
extern NSString * const kSMPersonDetailView;