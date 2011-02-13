//
//  KDLibrary.h
//  Amber
//
//  Created by Keith Duncan on 05/03/2008.
//  Copyright 2008 thirty-three. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AmberFoundation/NSBundle+Additions.h"

@class AFLibrary, AFSourceNode;

@protocol AFLibraryDelegate <AFBundleDiscovery>

- (BOOL)library:(AFLibrary *)library willDisplaySheetRequestingLibraryLocation:(NSURL **)locationRef;

 @optional

/*!
	@brief	Root children are NEVER selectable and you won't be queried.
 */
- (BOOL)library:(AFLibrary *)library isObjectSelectable:(id)object;

@end

/*!
    @brief
 
	This is an abstract class for loading XML library representations, iTunes initially, perhaps iPhoto or another custom store could be added.
*/
@interface AFLibrary : NSObject {
 @private
	id <AFLibraryDelegate> delegate;
	
	NSURL *_location;
	BOOL _shouldRequest;
	
	BOOL _loaded;
}

@property (assign) id <AFLibraryDelegate> delegate;

/*!
	@brief	Designated Initialiser.
	@param	|shouldRequest| pass YES to trigger a user request when loading the library, bypassing the search paths.
 */
- (id)initWithLocation:(NSURL *)location shouldRequest:(BOOL)shouldRequest;

@property (readonly, copy) NSURL *location;

/*
	@brief	This is an observable property.
 */
@property (readonly, assign, getter=isLoaded) BOOL loaded;

- (BOOL)loadAndReturnError:(NSError **)error;

/*
	@brief	This is for binding an NSTreeController to the library's source tree.
 */
@property (readonly, retain) AFSourceNode *rootNode;

- (NSMenu *)sourceMenu DEPRECATED_ATTRIBUTE;

@end

/*!
	@brief	Library subclasses MUST conform to this protocol.
 */
@protocol AFLibraryDiscovery <NSObject>
- (NSString *)name;
- (NSString *)expectedPath;
 @optional
- (NSArray *)additionalSearchPaths;
@end
