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
	fileUploader = [[FileUploader alloc] init];
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)path {
	[fileUploader uploadWithContentsOfFile:path];
	
	return YES;
}

- (void)dealloc {
	[fileUploader release];
	[super dealloc];
}

@end
