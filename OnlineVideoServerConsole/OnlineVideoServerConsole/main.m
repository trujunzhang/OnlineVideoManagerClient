//
//  main.m
//  OnlineVideoServerConsole
//
//  Created by djzhang on 12/29/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OnlineVideoStatisticsHelper.h"
#import "MobileDB.h"

#include <unistd.h>
#include <sys/types.h>
#include <pwd.h>
#include <assert.h>
#import "NSString+PJR.h"
#import "MobileBaseDatabase.h"


NSString * RealHomeDirectory() {
   struct passwd * pw = getpwuid(getuid());
   assert(pw);
   return [NSString stringWithUTF8String:pw->pw_dir];
}


NSString * RealProjectCacheDirectory() {
   NSString * homeDirectory = RealHomeDirectory();

   return [NSString stringWithFormat:@"%@%@", homeDirectory, @"/.AOnlineTutorial/.cache"];
}


BOOL cleanupCache(NSString * cacheDirectory) {
   NSString * dbFilePath = [cacheDirectory stringByAppendingPathComponent:dataBaseName];

   BOOL fileExists = [MobileBaseDatabase checkDBFileExist:dbFilePath];
   if (fileExists == NO) {
      return YES;
   }

   NSFileManager * filemgr;
   filemgr = [NSFileManager defaultManager];

   if ([filemgr removeItemAtPath:dbFilePath error:NULL] == YES) {
      return YES;
   }
   else {
      NSLog(@"Remove failed");
   }

   return NO;
}


void generateSqliteFromSource(NSString * onlineTypeName, NSString * onlineVideoTypePath, NSString * onlineTypeRoot, NSString * cacheDirectory) {

//   NSString * videoPath = @"/Volumes/XBMC/ShareAFP/Online Tutorial/Video Training/Lynda.com";
//   NSString * videoPath = @"/Volumes/macshare/MacPE/Lynda.com";

   OnlineVideoStatisticsHelper * onlineVideoStatisticsHelper =
    [[OnlineVideoStatisticsHelper alloc] initWithOnlinePath:onlineTypeRoot
                                                   withName:onlineTypeName];

   NSMutableDictionary * projectTypesDictionary = onlineVideoStatisticsHelper.projectTypesDictionary;

   [[MobileDB dbInstance:cacheDirectory] saveForOnlineVideoTypeDictionary:projectTypesDictionary
                                                                 withName:onlineTypeName
                                                 whithOnlineVideoTypePath:onlineVideoTypePath
   ];

   NSString * debug = @"debug";
}


int main(int argc, const char * argv[]) {
   @autoreleasepool {
      // insert code here...

      NSString * cacheDirectory = RealProjectCacheDirectory();
      if (cleanupCache(cacheDirectory) == NO) {
         NSLog(@"Remove failed");
         return 0;
      }

      NSString * htdocs = @"/Volumes";

      NSArray * youtubeArray = @[
       @"/Volumes/macshare/MacPE/youtubes",
       @"/Volumes/AppCache/TubeDownload",
      ];
      NSArray * lyndaArray = @[
       @"/Volumes/macshare/MacPE/Lynda.com",
      ];

      NSMutableDictionary * onlineTypeDictionary = @{
       @"Youtube.com" : youtubeArray,
       @"Lynda.com" : lyndaArray,
      };

      for (NSString * onlineTypeName in onlineTypeDictionary.allKeys) {
         NSArray * typePathArray = [onlineTypeDictionary valueForKey:onlineTypeName];

         for (NSString * onlineTypeRoot in typePathArray) {
            NSString * onlineVideoTypePath = [onlineTypeRoot replaceCharcter:htdocs
                                                                withCharcter:@""];
            generateSqliteFromSource(onlineTypeName, onlineVideoTypePath, onlineTypeRoot, cacheDirectory);
         }
      }

      NSLog(@"Hello, World!");
   }
   return 0;
}


