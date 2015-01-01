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


void generateSqliteFromSource(NSString * onlineTypeName, NSString * onlineVideoTypePath, NSString * videoScanFold, NSString * dbDirectory) {

//   NSString * videoPath = @"/Volumes/XBMC/ShareAFP/Online Tutorial/Video Training/Lynda.com";
//   NSString * videoPath = @"/Volumes/macshare/MacPE/Lynda.com";

   // 1
   OnlineVideoStatisticsHelper * onlineVideoStatisticsHelper = [[OnlineVideoStatisticsHelper alloc] initWithOnlinePath:videoScanFold withCacheDirectory:dbDirectory];

   // 2
   [[MobileDB dbInstance:dbDirectory] saveForOnlineVideoTypeDictionary:onlineVideoStatisticsHelper.projectTypesDictionary
                                                              withName:onlineTypeName
                                              whithOnlineVideoTypePath:onlineVideoTypePath
   ];
}


int main(int argc, const char * argv[]) {
   @autoreleasepool {
      // insert code here...

      NSString * dbDirectory = RealProjectCacheDirectory();
      if (cleanupCache(dbDirectory) == NO) {
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

         for (NSString * videoScanFold in typePathArray) {

            generateSqliteFromSource(
             onlineTypeName,// Youtube.com
             [videoScanFold replaceCharcter:htdocs withCharcter:@""],// local path: "/macshare/MacPE/youtubes"
             videoScanFold,// "/Volumes/macshare/MacPE/youtubes"
             dbDirectory// "/Volumes/Home/djzhang/.AOnlineTutorial/.cache"+"xxx.db"
            );

         }
      }

      NSLog(@"Hello, World!");
   }
   return 0;
}


