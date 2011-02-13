//
//  KDLibraryLocationWindowController.h
//  Amber
//
//  Created by Keith Duncan on 15/05/2008.
//  Copyright 2008 thirty-three. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AFLibrary;

/*
	@brief
 
	A simple window controller subclass designed to be presented as a sheet.
	It needs some design work as it looks pretty poor just now.
 
	@detail
 
	This window is designed to run modally, calling <tt>-requestLibraryLocation</tt> will
	display the winow as a sheet on <tt>[[NSApplication sharedApplication] mainWindow]</tt> and
	return once the sheet has been dismissed.
 */
@interface AFLocateLibraryWindowController : NSWindowController {
	AFLibrary *library;
	
	NSString *expectedLocation;
	NSTextField *libraryPathField;
}

- (id)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle;

@property (assign) AFLibrary *library;

@property (copy) NSString *expectedLocation;
@property (readonly, assign) IBOutlet NSTextField *libraryPathField;

- (NSURL *)requestLibraryLocation;

- (IBAction)browse:(id)sender;
- (IBAction)endRequest:(id)sender;

@end
