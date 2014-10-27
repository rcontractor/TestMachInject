//
//  FEInstaller.m
//
//  Created by Erwan Barrier on 8/11/12.
//  Copyright (c) 2012 Erwan Barrier. All rights reserved.
//

#import <ServiceManagement/ServiceManagement.h>

#import "FEInstaller.h"
#import "FEFrameworkInstaller.h"

enum {
    FEErrPermissionDenied  = 0,
    FEErrInstallHelperTool = 1,
    FEErrInstallFramework  = 2,
    FEErrInjection         = 3,
};

NSString *const FEErrorDomain = @"FinderInstaller.ErrorDomain";

NSString *const FEErrInstallDescription = @"An error occurred while installing FinderInstaller. Please report this to the author.";

NSString *const FEUserDefaultsInstalledVersionKey = @"InstalledVersion";

NSString *const FEInjectorExecutableLabel  = @"com.ruchi.TestMachInject.Injector";
NSString *const FEInstallerExecutableLabel = @"com.ruchi.TestMachInject.Installer";

@interface FEInstaller ()
+ (BOOL)askPermission:(AuthorizationRef *)authRef error:(NSError **)error;
+ (BOOL)installHelperTool:(NSString *)executableLabel authorizationRef:(AuthorizationRef)authRef error:(NSError **)error;
+ (BOOL)installMachInjectBundleFramework:(NSError **)error;
@end

@implementation FEInstaller

+ (BOOL)isInstalled {
    NSString *versionInstalled = [[NSUserDefaults standardUserDefaults] stringForKey:FEUserDefaultsInstalledVersionKey];
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    return ([currentVersion compare:versionInstalled] == NSOrderedSame);
}

+ (BOOL)install:(NSError **)error {
    AuthorizationRef authRef = NULL;
    BOOL result = YES;

    result = [self askPermission:&authRef error:error];

    if (result == YES) {
        result = [self installHelperTool:FEInstallerExecutableLabel authorizationRef:authRef error:error];
    }

    if (result == YES) {
        result = [self installMachInjectBundleFramework:error];
    }

    if (result == YES) {
        result = [self installHelperTool:FEInjectorExecutableLabel authorizationRef:authRef error:error];
    }

    if (result == YES) {
        NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:FEUserDefaultsInstalledVersionKey];
        NSLog(@"Installed v%@", currentVersion);
    }

    return result;
}

+ (BOOL)askPermission:(AuthorizationRef *)authRef error:(NSError **)error {
    NSString *promptText = @AUTHORIZATION_PROMPT @"\n\n";

    // Creating auth item to bless helper tool and install framework
    AuthorizationItem authItem = {kSMRightBlessPrivilegedHelper, 0, NULL, 0};
    
    // Creating a set of authorization rights
	AuthorizationRights authRights = {1, &authItem};
    
    // Specifying authorization options for authorization
	AuthorizationFlags flags = kAuthorizationFlagDefaults | kAuthorizationFlagInteractionAllowed | kAuthorizationFlagExtendRights;

    AuthorizationItem dialogConfiguration[1] = { kAuthorizationEnvironmentPrompt, [promptText length], (char *) [promptText UTF8String], 0 };
    
    AuthorizationEnvironment authorizationEnvironment = { 0 };
    authorizationEnvironment.items = dialogConfiguration;
    authorizationEnvironment.count = 1;

    // Open dialog and prompt user for password
	OSStatus status = AuthorizationCreate(&authRights, &authorizationEnvironment, flags, authRef);
    
    if (status == errAuthorizationSuccess) {
        return YES;
    } else {
        NSLog(@"Failed to create AuthorizationRef, return code %i", status);
        return NO;
    }
}

+ (BOOL)installHelperTool:(NSString *)executableLabel authorizationRef:(AuthorizationRef)authRef error:(NSError **)error {
    CFErrorRef blessError = NULL;
    BOOL result;

    result = SMJobBless(kSMDomainSystemLaunchd, (CFStringRef)executableLabel, authRef, &blessError);
    if (result == NO) {
        CFIndex errorCode = CFErrorGetCode(blessError);
        CFStringRef errorDomain = CFErrorGetDomain(blessError);

        NSLog(@"an error occurred while installing %@ (domain: %@ (%@))", executableLabel, errorDomain, [NSNumber numberWithLong:errorCode]);
        NSLog(@"%@", CFErrorCopyUserInfo(blessError));

    } else {
        NSLog(@"Installed %@ successfully", executableLabel);
    }
    
    return result;
}

+ (BOOL)installMachInjectBundleFramework:(NSError **)error {
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *frameworkPath = [[[resourcePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Frameworks"] stringByAppendingPathComponent:@"mach_inject_bundle.framework"];

    BOOL result = YES;
    
    NSConnection *c = [NSConnection connectionWithRegisteredName:@"com.ruchi.TestMachInject.Installer.mach" host:nil];
    assert(c != nil);

    FEFrameworkInstaller *installer = (FEFrameworkInstaller *)[c rootProxy];
    assert(installer != nil);
    
    result = [installer installFramework:frameworkPath];
    
    if (result == YES) {
        NSLog(@"Installed mach_inject_bundle.framework successfully");
    } else {
        NSLog(@"an error occurred while installing mach_inject_bundle.framework (domain: %@ code: %@)", installer.error.domain, [NSNumber numberWithInteger:installer.error.code]);
    }
 
    return result;
}

@end