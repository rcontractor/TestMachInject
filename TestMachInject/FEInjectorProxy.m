//
//  InjectorWrapper.m
//  Dark
//
//  Created by Erwan Barrier on 8/6/12.
//  Copyright (c) 2012 Erwan Barrier. All rights reserved.
//

#import <ServiceManagement/ServiceManagement.h>
#import <AppKit/AppKit.h>
#import <mach/mach_error.h>

#import "FEInjector.h"
#import "FEInjectorProxy.h"

@implementation FEInjectorProxy

//+ (BOOL)inject:(NSError **)error withBundlePath:(NSString *)bundlePath {
+ (BOOL)inject:(NSError **)error {
    NSConnection *c = [NSConnection connectionWithRegisteredName:@"com.ruchi.TestMachInject.Injector.mach" host:nil];
    assert(c != nil);
    
    FEInjector *injector = (FEInjector *)[c rootProxy];
    assert(injector != nil);
    
    pid_t pid = [[[NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.apple.finder"]
                  lastObject] processIdentifier];

    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Payload" ofType:@"bundle"];
    
    NSLog(@"Injecting Finder (%@) with %@", [NSNumber numberWithInt:pid], bundlePath);

    mach_error_t err;
    char *mach_err;
    @try {
        err = [injector inject:pid withBundle:bundlePath];
    }
    @catch (NSException *exception) {
        NSLog(@"mach error injector Exception: %@", exception);
    }
    @finally {
        if (err == 0) {
            NSLog(@"Injected Finder");
            return YES;
        } else {
            NSLog(@"MACH ERR IS %u", err);
            mach_err = mach_error_string(err);
            if (mach_err != NULL)
                NSLog(@"an error occurred while injecting Finder: %@ (error code: %@)", [NSString stringWithCString:mach_err encoding:NSASCIIStringEncoding], [NSNumber numberWithInt:err]);
            
            /**error = [[NSError alloc] initWithDomain:FEErrorDomain
             code:FEErrInjection
             userInfo:@{NSLocalizedDescriptionKey: FEErrInjectionDescription}];
             */
            return NO;
        }
    }

}
@end
