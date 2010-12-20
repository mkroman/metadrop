//
//  FileUploader.h
//  Metadrop
//
//  Created by Mikkel Kroman on 12/18/10.
//  Copyright 2010 Maero. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FileUploader : NSObject {
	NSURL *uploadURL;
	NSMutableData *receivedData;
}

- (void)uploadWithContentsOfFile:(NSString *)path;

@end
