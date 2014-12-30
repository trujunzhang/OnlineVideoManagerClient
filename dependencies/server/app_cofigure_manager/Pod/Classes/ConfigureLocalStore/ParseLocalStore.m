//
// Created by djzhang on 12/30/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "ParseLocalStore.h"


@implementation ParseLocalStore {

}

+ (void)saveSqliteVersion:(NSString *)version {
   NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
   [defaults setObject:version forKey:@"sqlite_version"];
   [defaults synchronize];
}


+ (NSString *)readSqliteVersion {
   NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
   if ([defaults objectForKey:@"sqlite_version"]) {
      return [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"sqlite_version"]];
   }

   return @"";
}


+ (BOOL)checkLocalCacheSqliteExist:(NSString *)filePathName {
   BOOL myPathIsDir;
   BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePathName isDirectory:&myPathIsDir];

   return fileExists;
}


@end