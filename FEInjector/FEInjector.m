//
// FEInjector.m
//
//  Created by Erwan Barrier, modified by Ruchi Contractor on 12/18/12.
//  Copyright (c) 2012 Erwan Barrier. All rights reserved.
//

#import "FEInjector.h"

#import "mach_inject_bundle.h"
#import <mach/mach_error.h>

@implementation FEInjector

- (mach_error_t)inject:(pid_t)pid withBundle:(NSString *)bundlePath {
    mach_error_t err = err_none;

    // Disarm timer while installing framework
    dispatch_source_set_timer(g_timer_source, DISPATCH_TIME_FOREVER, 0llu, 0llu);

    NSLog(@"TEST  Inject INJECTOR!");

    err = mach_inject_bundle_pid([bundlePath fileSystemRepresentation], pid);
    if (err == err_none) {
        NSLog(@"Inject successful!");
    } else {
        NSLog(@"Inject error: %d", err);
    }

    // Rearm timer
    dispatch_time_t t0 = dispatch_time(DISPATCH_TIME_NOW, 5llu * NSEC_PER_SEC);
    dispatch_source_set_timer(g_timer_source, t0, 0llu, 0llu);

    return err;
}

@end