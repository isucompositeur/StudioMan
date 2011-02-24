//
//  AFSourceList.h
//  Amber
//
//  Created by Keith Duncan on 04/05/2007.
//  Copyright 2007 thirty-three. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AmberKit/AFKeyValueBinding.h"

@class AFTextFieldCell, AFImageTextCell;

@protocol AFSourceListDelegateProtocol;
@protocol AFSourceListDataSourceProtocol;

extern NSString *AFContentImagesBinding;

/*!
	@brief
	An iLife '08 style sidebar.
 
	@detail
	This is a bindings driven view that displays a hierarchy of data like an outline view
	
	Exposed Bindings:
 
	- Required Bindings
	
	• <tt>NSContentBinding</tt>, the arrangedObjects object of an NSTreeController or another compatable controller.
	• <tt>AFContentImagesBinding</tt>, the key path by which the images are retrieved. This key path should be prefixed with @"arrangedObjects| or equivalent so that it can be observed.
	• <tt>NSContentValuesBinding</tt>, the key path by which the item titles are retrieved. This key path should be prefixed with @"arrangedObjects| or equivalent so that it can be observed.
	
	- Optional Bindings
	
	• <tt>AFSelectionIndexPathBinding</tt>, only a single index path is used, it's singular because a user shouldn't be able to select multiple rows in a source list.
	• <tt>NSSelectedValueBinding</tt>, this is the selected item's title.
 */
@interface AFSourceList : NSControl <AFKeyValueBinding> {
 @private
	id <AFSourceListDelegateProtocol> _delegate;
	id <AFSourceListDataSourceProtocol> _dataSource;
	
	NSMutableDictionary *_bindingInfo;
	
	AFImageTextCell *_contentsCell;
	
	CGFloat _rowHeight, _nodeSeparation;
	
	NSMutableSet *_expanded, *_expandable, *_disclosureButtons;
	NSCountedSet *_disclosureLevels;
}

@property (assign) IBOutlet id <AFSourceListDelegateProtocol> delegate;

@property (assign) IBOutlet id <AFSourceListDataSourceProtocol> dataSource;

@end


@protocol AFSourceListDelegateProtocol <NSObject>

 @optional

/*!
	@brief
	Root children are NEVER selectable and you won't be queried.
 */
- (BOOL)sourceList:(AFSourceList *)view canSelectObject:(id)node;

/*!
	@brief
	Root children without leaves are expected to be removed, return YES here to override this.
 */
- (BOOL)sourceList:(AFSourceList *)view shouldDisplayRootLeaf:(id)node;

@end


@protocol AFSourceListDataSourceProtocol <NSObject>

 @optional

/*!
	@brief
	You will only be asked about objects with children. Root children default to NO like the 10.5 Finder.
	
	@param
	|showDisclosure| is passed by pointer so that you can respect the default implementation.
 */
- (void)sourceList:(AFSourceList *)view shouldDisplayDisclosure:(BOOL *)showDisclosure forObject:(id)object;

@end
