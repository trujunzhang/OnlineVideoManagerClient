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


#import "ServerVideoConfigure.h"
#import "VideoGenerateSqliteHelper.h"


void emptyCacheThumbnailDirectory(NSFileManager * filemgr, NSString * dirToEmpty) {
   NSFileManager * manager = [NSFileManager defaultManager];
   NSError * error = nil;
   NSArray * files = [manager contentsOfDirectoryAtPath:dirToEmpty
                                                  error:&error];

   if (error) {
      //deal with error and bail.
      return;
   }

   for (NSString * file in files) {
      [manager removeItemAtPath:[dirToEmpty stringByAppendingPathComponent:file]
                          error:&error];
      if (error) {
         //an error occurred...
      }
   }
}


void createDirectoryForCache(NSFileManager * filemgr, NSString * cacheDirectory, NSString * thumbnailDirectory) {
   NSError * error = nil;
   if (![filemgr createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:&error]) {
      // An error has occurred, do something to handle it
      NSLog(@"Failed to create directory \"%@\". Error: %@", cacheDirectory, error);
   }


   if (![filemgr createDirectoryAtPath:thumbnailDirectory
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:&error]) {
      // An error has occurred, do something to handle it
      NSLog(@"Failed to create directory \"%@\". Error: %@", thumbnailDirectory, error);
   }
}


BOOL cleanupCache(NSString * cacheDirectory) {
   NSFileManager * filemgr = [NSFileManager defaultManager];

   NSString * dbFilePath = [cacheDirectory stringByAppendingPathComponent:dataBaseName];

   NSString * thumbnailDirectory = [NSString stringWithFormat:@"%@/%@",
                                                              cacheDirectory,
                                                              thumbnailFolder];

   BOOL fileExists = [MobileBaseDatabase checkDBFileExist:dbFilePath];
   if (fileExists == NO) {
      createDirectoryForCache(filemgr, cacheDirectory, thumbnailDirectory);
      return YES;
   }

   emptyCacheThumbnailDirectory(filemgr, thumbnailDirectory);

   if ([filemgr removeItemAtPath:dbFilePath error:NULL] == YES) {
      return YES;
   }
   else {
      NSLog(@"Remove failed");
   }

   return NO;
}


int main(int argc, const char * argv[]) {
   @autoreleasepool {
      // insert code here...

      NSString * dbDirectory = RealProjectCacheDirectory();

      if (cleanupCache(dbDirectory) == NO) {
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
                                                                 saveSqlitTo:dbDirectory// "/Volumes/Home/djzhang/.AOnlineTutorial/.cache"+"xxx.db"
            ];

         }
      }

      NSLog(@"Hello, World!");
   }
   return 0;
}


