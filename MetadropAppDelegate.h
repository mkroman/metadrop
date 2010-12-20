//
//  MetadropAppDelegate.h
//  Metadrop
//
//  Created by Mikkel Kroman on 12/18/10.
//  Copyright 2010 Maero. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FileUploader.h"

@interface MetadropAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
