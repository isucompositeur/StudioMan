//
//  KDLibrary.m
//  Amber
//
//  Created by Keith Duncan on 05/03/2008.
//  Copyright 2008 thirty-three. All rights reserved.
//

#import "AFLibrary.h"

#import "AFSourceNode.h"

#import "AFLocateLibraryWindowController.h"

@interface AFLibrary ()
@property (readwrite, copy) NSURL *location;
@property (readwrite, assign) BOOL shouldRequest;
@property (readwrite, assign, getter=isLoaded) BOOL loaded;
@end

@implementation AFLibrary

@synthesize delegate;
@synthesize location=_location;
@synthesize shouldRequest=_shouldRequest;
@synthesize loaded=_loaded;
@dynamic rootNode;

- (id)initWithLocation:(NSURL *)location shouldRequest:(BOOL)shouldRequest {
	self = [self init];
	if (self == nil) return nil;
	
	self.location = location;
	self.shouldRequest = shouldRequest;
	
	return self;
}

- (void)dealloc {
	self.location = nil;
	
	[super dealloc];
}

- (NSBundle *)bundle {
	return [self.delegate bundle];
}

- (BOOL)loadAndReturnError:(NSError **)error {
	if (self.loaded) return YES;
	
	BOOL libraryFound = NO;
	if (!self.shouldRequest) {
		NSMutableArray *searchPaths = [NSMutableArray array];
		
		if (self.location != nil) [searchPaths addObject:self.location];
		
		[searchPaths addObject:[(id)self expectedPath]];
		if ([self respondsToSelector:@selector(additionalSearchPaths)])
			[searchPaths addObjectsFromArray:[(id)self additionalSearchPaths]];
		
		for (NSURL *currentLocation in searchPaths) {
			if (!AFFileExistsAtPath([currentLocation path])) continue;
			
			libraryFound = YES;
			self.location = currentLocation;
			
			break;
		}
	}
		
	if (self.shouldRequest || !libraryFound) {
		BOOL continueRequest = YES;
		NSURL *requestLocation = nil;
		
		if ([self.delegate respondsToSelector:@selector(library:willDisplaySheetRequestingLibraryLocation:)]) {
			continueRequest = [self.delegate library:self willDisplaySheetRequestingLibraryLocation:&requestLocation];
		}
		
		if (continueRequest && requestLocation == nil) {
			AFLocateLibraryWindowController *controller = [[AFLocateLibraryWindowController alloc] initWithNibName:@"AFSourceListLibraryLocator" bundle:nil];
			controller.library = self;
			controller.expectedLocation = [self.location path];
			
			requestLocation = [controller requestLibraryLocation];
			
			[controller release];
		}
		
		self.location = requestLocation;
	}
	
	if (!AFFileExistsAtPath([self.location path])) {
		if (error != NULL)
			*error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileNoSuchFileError userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Could not locate library.", NSLocalizedDescriptionKey, nil]];
		
		return NO;
	}
	
	return YES;
}

- (NSMenuItem *)_createMenuItemForNode:(AFSourceNode *)node {
	NSMenuItem *nodeMenuItem = [[NSMenuItem alloc] init];
	
	[nodeMenuItem setImage:node.image];
	[nodeMenuItem setTitle:[node.name stringByAppendingElipsisAfterCharacters:30]];
	
	[nodeMenuItem setEnabled:([self.delegate respondsToSelector:@selector(library:isObjectSelectable:)] ? [self.delegate library:self isObjectSelectable:node] : YES)];
	[nodeMenuItem setIndentationLevel:([[node indexPath] length] - 1)];
	
	return nodeMenuItem;
}

- (void)_addChildNodes:(AFSourceNode *)node to:(NSMenu *)menu {
	for (AFSourceNode *currentNode in [node childNodes]) {
		NSMenuItem *currentNodeMenuItem = [self _createMenuItemForNode:currentNode];
		
		[menu addItem:currentNodeMenuItem];
		[self _addChildNodes:currentNode to:menu];
		
		[currentNodeMenuItem release];
	}
}

- (NSMenu *)sourceMenu {
	NSMenu *sourceMenu = [[NSMenu alloc] init];
	[sourceMenu setAutoenablesItems:NO];
	
	for (AFSourceNode *rootChild in [self.rootNode childNodes]) {
		[self _addChildNodes:rootChild to:sourceMenu];
		
		if (rootChild != [[self.rootNode childNodes] lastObject])
			[sourceMenu addItem:[NSMenuItem separatorItem]];
	}
	
	return [sourceMenu autorelease];
}

@end
