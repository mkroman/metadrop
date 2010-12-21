#import "ApplicationDelegate.h"

@implementation ApplicationDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	fileUploader = [[FileUploader alloc] initWithDelegate:self];
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)path {
	[fileUploader uploadWithContentsOfFile:path];
	
	return YES;
}

- (void)fileUploader:(FileUploader *)uploader didChangeProgress:(NSNumber *)progress {
	if ([progress intValue] % 2 == 0)
		[[[NSApplication sharedApplication] dockTile] setBadgeLabel:[NSString stringWithFormat:@"%d%%", [progress intValue]]];

	NSLog(@"Progress: %@%%", [progress stringValue]);
}

- (void)fileUploader:(FileUploader *)uploader didRetrieveRemoteLocation:(NSString *)url {
	[[[NSApplication sharedApplication] dockTile] setBadgeLabel:@"Done!"];
	
	[self performSelector:@selector(hideBadgeLabel) withObject:nil afterDelay:5.0];
	
	NSPasteboard *paste = [NSPasteboard generalPasteboard];
	[paste declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:self];
	[paste setString:url forType:NSStringPboardType];
	
	NSLog(@"Successfully uploaded at %@", url);
}

- (void)fileUploader:(FileUploader *)uploader didFailWithStringError:(NSString *)error {
	[[[NSApplication sharedApplication] dockTile] setBadgeLabel:@"Error!"];
	
	[self performSelector:@selector(hideBadgeLabel) withObject:nil afterDelay:5.0];
	
	NSLog(@"Failed to upload file: %@", error);
}

- (void)hideBadgeLabel {
	[[[NSApplication sharedApplication] dockTile] setBadgeLabel:nil];
}

- (void)dealloc {
	[fileUploader release];
	[super dealloc];
}

@end
