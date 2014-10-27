//
//  InjectorWrapper.h
//  Dark
//
//  Created by Erwan Barrier on 8/6/12.
//  Copyright (c) 2012 Erwan Barrier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FEInjectorProxy : NSObject

+ (BOOL)inject:(NSError **)error;
//+ (BOOL)inject:(NSError **)error withBundlePath:(NSString *)bundlePath;

@end