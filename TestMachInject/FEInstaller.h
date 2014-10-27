//
//  FEInstaller.h
//
//  Created by Erwan Barrier on 8/11/12.
//  Copyright (c) 2012 Erwan Barrier. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const FEInjectorExecutableLabel;
FOUNDATION_EXPORT NSString *const FEInstallerExecutableLabel;

@interface FEInstaller : NSObject

+ (BOOL)isInstalled;
+ (BOOL)install:(NSError **)error;
@end

#define	AUTHORIZATION_PROMPT	"Zimbra Sync and Share can also give you right click options from your sync folder in Finder. Complete this install to activate these additional features. You may need to restart your computer after installation."
