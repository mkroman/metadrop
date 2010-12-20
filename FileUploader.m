//
//  FileUploader.m
//  Metadrop
//
//  Created by Mikkel Kroman on 12/18/10.
//  Copyright 2010 Maero. All rights reserved.
//

#import "FileUploader.h"


@implementation FileUploader

- (id)init {
	if (!(self = [super init])) return nil;
	uploadURL = [[NSURL alloc] initWithString:@"http://metabox.it/"];
	return self;
}

- (void)dealloc {
	[uploadURL release];
	[super dealloc];
}

- (void)uploadWithContentsOfFile:(NSString *)path {
	if (![[NSFileManager defaultManager] fileExistsAtPath:path])
		return;
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:uploadURL];
	
	NSString *boundary = [NSString stringWithString:@"----------ThIs_Is_tHe_bouNdaRY_$"];
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
	
	[file release];
	[requestBody release];
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	[request release];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	if ([result hasPrefix:@"http://"]) {
		NSRunAlertPanel(@"Metabox", @"The file was successfully uploaded.\r\n\r\nYour clipboard is now containing the address for the file.", nil, nil, nil);
		
		NSPasteboard *paste = [NSPasteboard generalPasteboard];
		NSArray *types = [NSArray arrayWithObjects:NSStringPboardType, nil];
		
		[paste declareTypes:types owner:self];
		[paste setString:result forType:NSStringPboardType];
	} else {
		NSRunCriticalAlertPanel(@"Metabox", result, nil, nil, nil);
	}
	
	[result release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[connection release];
}

@end
