//
// Created by djzhang on 12/26/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "OnlineVideoStatisticsHelper.h"
#import "ABProjectName.h"
#import "ABProjectType.h"
#import "OnlineVideoProjectStatisticsHelper.h"
#import "OnlineVideoConstant.h"


@implementation OnlineVideoStatisticsHelper {

}

- (instancetype)initWithOnlinePath:(NSString *)onlinePath {
   self = [super init];
   if (self) {
      self.onlinePath = onlinePath;
      self.projectTypesDictionary = [[NSMutableDictionary alloc] init];

      [self analysisPath:onlinePath withDictionaryKey:@""];
   }

   return self;
}


- (void)analysisPath:(NSString *)appDocDir withDictionaryKey:(NSString *)key {
   NSArray * contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appDocDir error:NULL];
   int count = 1;
   for (NSString * aPath in contentOfFolder) {
      NSString * fullPath = [appDocDir stringByAppendingPathComponent:aPath];
      BOOL isDir = NO;
      if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir]) {
         if (isDir == YES) {
            NSLog(@"dir-%d: %@", count, fullPath);
            count++;
            TFOLD_TYPE type = [self checkDirType:aPath];
            switch (type) {
               case TFOLD_CATELOGY: {
                  ABProjectType * projectType = [[ABProjectType alloc] initWithProjectType:aPath];
                  [self.projectTypesDictionary setObject:projectType forKey:aPath];
                  [self analysisProjectNameListInProjectType:fullPath to:projectType];
               };
                  break;
               default:
                  [self analysisPath:fullPath withDictionaryKey:key];
                  break;
            }
         } else {

         }
      }
   }
}


- (void)analysisProjectNameListInProjectType:(NSString *)appDocDir to:(ABProjectType *)projectType {
   NSArray * contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appDocDir error:NULL];
   int count = 1;
   for (NSString * aPath in contentOfFolder) {
      NSString * fullPath = [appDocDir stringByAppendingPathComponent:aPath];
      BOOL isDir = NO;
      if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir]) {
         if (isDir == YES) {
            NSLog(@"dir-%d: %@", count, fullPath);
            count++;
            TFOLD_TYPE type = [self checkDirType:aPath];
            switch (type) {
               case TFOLD_PROJECT: {
                  [self makeProjectListWithProjectType:projectType aPath:aPath fullPath:fullPath];
               };
                  break;
               default:
                  [self analysisProjectNameListInProjectType:fullPath to:projectType];
                  break;
            }
         }
      }
   }
}


- (void)makeProjectListWithProjectType:(ABProjectType *)projectType aPath:(NSString *)aPath fullPath:(NSString *)fullPath {
   OnlineVideoProjectStatisticsHelper * onlineVideoProjectStatisticsHelper =
    [[OnlineVideoProjectStatisticsHelper alloc] initWithOnlinePath:self.onlinePath];

   [onlineVideoProjectStatisticsHelper makeProjectList:aPath withFullPath:fullPath to:projectType];
}


- (TFOLD_TYPE)checkDirType:(NSString *)path {
   NSUInteger length = [path length];
   if (length >= 2 && [[path substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"@@"]) {
      return TFOLD_PROJECT;
   }
   else if (length >= 1 && [[path substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"@"]) {
      return TFOLD_CATELOGY;
   }

   return -1;
}


- (BOOL)checkIsFile:(NSString *)pathToFile {
   pathToFile = @"Adobe.com/@Muse/#Muse Essential Training by Justin Seeley/0. Introduction";
//   pathToFile = @"Adobe.com/@Muse/#Muse Essential Training by Justin Seeley/0. Introduction/03-How to send feedback.mp4";

   BOOL isDir = NO;
   if ([[NSFileManager defaultManager] fileExistsAtPath:pathToFile isDirectory:&isDir] && isDir) {
      NSLog(@"Is directory");
      return NO;
   }

   return YES;
}


@end