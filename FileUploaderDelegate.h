@class FileUploader;

@protocol FileUploaderDelegate
@optional
- (void)fileUploader:(FileUploader *)uploader didChangeProgress:(NSNumber *)progress;
- (void)fileUploader:(FileUploader *)uploader didRetrieveRemoteLocation:(NSString *)url;
- (void)fileUploader:(FileUploader *)uploader didFailWithStringError:(NSString *)error;
@end