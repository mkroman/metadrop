#import "FileUploaderDelegate.h"

@interface FileUploader : NSObject {
	id delegate;
	NSURL *uploadURL;
	NSMutableData *receivedData;
}

- (id)initWithDelegate:(id)object;

- (void)uploadWithContentsOfFile:(NSString *)path;

@end