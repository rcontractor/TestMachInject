//
//  AppDelegate.m
//  TestMachInject
//
//  Created by Ruchi Contractor on 10/3/14.
//  Copyright (c) 2014 Ruchi Contractor. All rights reserved.
//

#import "AppDelegate.h"
#import "FEInstaller.h"
#import "FEInjectorProxy.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSError *error;
    
    // Install helper tools
    if ([FEInstaller isInstalled] == NO && [FEInstaller install:&error] == NO) {
        assert(error != nil);
        
        NSLog(@"Couldn't install MachInjectSample (domain: %@ code: %@)", error.domain, [NSNumber numberWithInteger:error.code]);
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert runModal];
        [NSApp terminate:self];
    }
    
    // Inject Finder process
    if ([FEInjectorProxy inject:&error] == FALSE) {
        assert(error != nil);
        
        NSLog(@"Couldn't inject Finder (domain: %@ code: %@)", error.domain, [NSNumber numberWithInteger:error.code]);
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert runModal];
        [NSApp terminate:self];
    }

}

@end