//
//  KDLibraryLocationWindowController.m
//  Amber
//
//  Created by Keith Duncan on 15/05/2008.
//  Copyright 2008 thirty-three. All rights reserved.
//

#import "AFLocateLibraryWindowController.h"

@interface AFLocateLibraryWindowController ()
@property (readwrite, assign) NSTextField *libraryPathField;
@end

@implementation AFLocateLibraryWindowController

@synthesize library;
@synthesize expectedLocation;
@synthesize libraryPathField;

- (id)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle {
	return [self initWithWindowNibName:name owner:self];
}

- (void)windowDidLoad; {
	[super windowDidLoad];
	
	[[self window] setContentBorderThickness:(25.0 + 16.0) forEdge:NSMinYEdge];
}

- (void)dealloc {
	self.expectedLocation = nil;
	
	[super dealloc];
}

- (IBAction)browse:(id)sender {
	NSOpenPanel *open = [NSOpenPanel openPanel];
	
	[open setCanChooseDirectories:NO];
	[open setCanCreateDirectories:NO];
	[open setAllowsMultipleSelection:NO];
	
	if ([open runModalForDirectory:[expectedLocation stringByDeletingLastPathComponent] file:nil types:[NSArray arrayWithObject:@"xml"]] == NSOKButton) {
		[self.libraryPathField setStringValue:[open filename]];
		[self endRequest:sender];
	}
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
	[sheet orderOut:nil]; 
}

- (NSURL *)requestLibraryLocation {
	[[NSApplication sharedApplication] beginSheet:[self window] modalForWindow:[[NSApplication sharedApplication] mainWindow] modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:NULL];
	
	[[NSApplication sharedApplication] runModalForWindow:[self window]];
	[[NSApplication sharedApplication] endSheet:[self window]];
	
	return [NSURL fileURLWithPath:[self.libraryPathField stringValue]];
}

- (IBAction)endRequest:(id)sender {
	[[NSApplication sharedApplication] stopModal];
}

@end
