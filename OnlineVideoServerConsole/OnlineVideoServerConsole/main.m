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


#import "VideoGenerateSqliteHelper.h"
#import "ServerVideoConfigure.h"
#import "UserCacheFolderHelper.h"


int main(int argc, const char * argv[]) {
   @autoreleasepool {
      // insert code here...


      if ([UserCacheFolderHelper cleanupCache] == NO) {
         NSLog(@"Remove failed");
         return 0;
      }

      NSMutableDictionary * onlineTypeDictionary = @{
       @"Youtube.com" : [ServerVideoConfigure youtubeArray],
       @"Lynda.com" : [ServerVideoConfigure lyndaArray],
      };

      for (NSString * onlineTypeName in onlineTypeDictionary.allKeys) {
         NSArray * typePathArray = [onlineTypeDictionary valueForKey:onlineTypeName];

         for (NSString * videoScanFold in typePathArray) {
            [VideoGenerateSqliteHelper generateSqliteFromSourcenWithTypeName:onlineTypeName// Youtube.com
                                                               withLocalPath:[videoScanFold replaceCharcter:htdocs
                                                                                               withCharcter:@""]// local path: "/macshare/MacPE/youtubes"
                                                              withScanFolder:videoScanFold// "/Volumes/macshare/MacPE/youtubes"
                                                                 saveSqlitTo:[UserCacheFolderHelper RealProjectCacheDirectory]// "/Volumes/Home/djzhang/.AOnlineTutorial/.cache"+"xxx.db"
            ];

         }
      }

      NSLog(@"Hello, World!");
   }
   return 0;
}


