#import "FileUploader.h"

@implementation FileUploader

- (id)init {
	if (!(self = [super init])) return nil;
	
	uploadURL = [[NSURL alloc] initWithString:@"http://metabox.it/"];
	receivedData = [[NSMutableData alloc] init];
	
	return self;
}

- (id)initWithDelegate:(id)object {
	if (self = [self init])
		delegate = object;
	
	return self;
}

- (void)dealloc {
	[receivedData release];
	[uploadURL release];
	
	[super dealloc];
}

- (void)uploadWithContentsOfFile:(NSString *)path {
	if (![[NSFileManager defaultManager] fileExistsAtPath:path])
		return;
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:uploadURL];
	
	NSString *boundary = [NSString stringWithString:@"FIGHT-THE-POWER"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	
	[request setHTTPMethod:@"POST"];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *requestBody = [[NSMutableData alloc] init];
	NSData *file = [[NSData alloc] initWithContentsOfFile:path];
	NSString *filename = [[path componentsSeparatedByString:@"/"] lastObject];
	
	[requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
	[requestBody appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[requestBody appendData:file];
	[requestBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[request setHTTPBody:requestBody];
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	[file release];
	[request release];
	[requestBody release];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	
	if ([response hasPrefix:@"http://"]) {
	 	if ([delegate respondsToSelector:@selector(fileUploader:didRetrieveRemoteLocation:)]) 
			[delegate fileUploader:self didRetrieveRemoteLocation:[response substringToIndex:[response length]-1]];
	} else {
		NSRunCriticalAlertPanel(@"Metabox", response, nil, nil, nil);
	}
	
	[response release];
	[connection release];
	[receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
	NSNumber *progress = [NSNumber numberWithFloat:(float)totalBytesWritten / (float)totalBytesExpectedToWrite * 100.0];
	
	if ([delegate respondsToSelector:@selector(fileUploader:didChangeProgress:)])
		[delegate fileUploader:self didChangeProgress:progress];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[receivedData setLength:0];
	[connection release];
}

@end
