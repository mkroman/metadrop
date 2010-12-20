//
//  MetadropAppDelegate.m
//  Metadrop
//
//  Created by Mikkel Kroman on 12/18/10.
//  Copyright 2010 Maero. All rights reserved.
//

#import "MetadropAppDelegate.h"

@implementation MetadropAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)path {
	FileUploader *fileUploader = [[FileUploader alloc] init];
	[fileUploader uploadWithContentsOfFile:path];
	[fileUploader release];
	
	return YES;
}

- (void)dealloc {
	[super dealloc];
}

@end
