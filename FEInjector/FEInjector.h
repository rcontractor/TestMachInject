//
//  FEInjector.h
//  Dark
//
//  Created by Ruchi Contractor on 12/18/12.
//  Copyright (c) 2012 Ruchi Contractor. All rights reserved.
//

#import <Foundation/Foundation.h>

extern dispatch_source_t g_timer_source;

@interface FEInjector : NSObject

- (mach_error_t)inject:(pid_t)pid withBundle:(NSString *)bundlePackageFileSystemRepresentation;

@end