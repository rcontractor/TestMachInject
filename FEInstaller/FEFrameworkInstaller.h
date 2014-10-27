//
//  FEInstaller.h
//
//  Created by Erwan Barrier on 8/11/12.
//  Copyright (c) 2012 Erwan Barrier. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const FEFrameworkDstPath;

extern dispatch_source_t g_timer_source;

@interface FEFrameworkInstaller : NSObject
{
//    NSError *_error;
}

@property (nonatomic, strong) NSError *error;

- (BOOL)installFramework:(NSString *)frameworkPath;

@end
