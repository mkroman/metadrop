#import "FileUploader.h"

@interface ApplicationDelegate : NSObject <NSApplicationDelegate, FileUploaderDelegate> {
    NSWindow *window;
	FileUploader *fileUploader;
}

@property (assign) IBOutlet NSWindow *window;

@end
