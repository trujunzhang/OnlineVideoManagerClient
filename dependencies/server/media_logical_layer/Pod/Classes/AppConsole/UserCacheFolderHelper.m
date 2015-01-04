//
// Created by djzhang on 1/4/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import "UserCacheFolderHelper.h"
#include <unistd.h>
#include <sys/types.h>
#include <pwd.h>
#include <assert.h>


@implementation UserCacheFolderHelper {

}


+ (NSString *)RealHomeDirectory {
   struct passwd * pw = getpwuid(getuid());
   assert(pw);
   return [NSString stringWithUTF8String:pw->pw_dir];
}


+ (NSString *)RealProjectCacheDirectory {
   NSString * homeDirectory = [UserCacheFolderHelper RealHomeDirectory];

   return [NSString stringWithFormat:@"%@/%@/%@", homeDirectory, appProfile, appCacheDirectory];
}

@end