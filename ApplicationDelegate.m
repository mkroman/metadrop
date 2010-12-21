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
	NSLog(@"Progress: %d%%", [progress intValue]);
}

- (void)fileUploader:(FileUploader *)uploader didRetrieveRemoteLocation:(NSString *)url {
	NSLog(@"Successfully uploaded at %@", url);
}

- (void)dealloc {
	[fileUploader release];
	[super dealloc];
}

@end
