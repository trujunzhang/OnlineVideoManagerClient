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


NSString * RealHomeDirectory() {
   struct passwd * pw = getpwuid(getuid());
   assert(pw);
   return [NSString stringWithUTF8String:pw->pw_dir];
}


NSString * RealProjectCacheDirectory() {
   NSString * homeDirectory = RealHomeDirectory();

   return [NSString stringWithFormat:@"%@%@", homeDirectory, @"/.AOnlineTutorial/.cache"];
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
      NSString * htdocs = @"/Volumes";

      NSString * cacheDirectory = RealProjectCacheDirectory();

      NSMutableDictionary * onlineTypeDictionary = @{
       @"Lynda.com" : @"/Volumes/macshare/MacPE/Lynda.com"
      };

      for (NSString * onlineTypeName in onlineTypeDictionary.allKeys) {
         NSString * onlineTypeRoot = [onlineTypeDictionary valueForKey:onlineTypeName];
         NSString * onlineVideoTypePath = [onlineTypeRoot replaceCharcter:htdocs
                                                             withCharcter:@""];
         generateSqliteFromSource(onlineTypeName, onlineVideoTypePath, onlineTypeRoot, cacheDirectory);
      }

      NSLog(@"Hello, World!");
   }
   return 0;
}


