//
//  DKInstaller.m
//  Dark
//
//  Created by Erwan Barrier on 8/11/12.
//  Copyright (c) 2012 Erwan Barrier. All rights reserved.
//

#import "FEFrameworkInstaller.h"

NSString *const FEFrameworkDstPath = @"/Library/Frameworks/mach_inject_bundle.framework";

@implementation FEFrameworkInstaller

@synthesize error = _error;

- (BOOL)installFramework:(NSString *)frameworkPath {
  // Disarm timer while installing framework
  dispatch_source_set_timer(g_timer_source, DISPATCH_TIME_FOREVER, 0llu, 0llu);

  NSError *fileError;
  BOOL result = YES;

  if ([[NSFileManager defaultManager] fileExistsAtPath:FEFrameworkDstPath] == YES) {
    result = [[NSFileManager defaultManager] removeItemAtPath:FEFrameworkDstPath error:&fileError];
  }

  if (result == YES) {
    result = [[NSFileManager defaultManager] copyItemAtPath:frameworkPath toPath:FEFrameworkDstPath error:&fileError];
  }

  if (result == NO) {
    _error = fileError;
  }

  // Rearm timer
  dispatch_time_t t0 = dispatch_time(DISPATCH_TIME_NOW, 5llu * NSEC_PER_SEC);
  dispatch_source_set_timer(g_timer_source, t0, 0llu, 0llu);

  return result;
}

@end
