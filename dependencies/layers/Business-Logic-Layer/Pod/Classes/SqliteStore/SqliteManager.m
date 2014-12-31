//
// Created by djzhang on 12/27/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "SqliteManager.h"
#import "MobileDB.h"
#import "YoutubeConstants.h"
#import "AnimatedContentsDisplayLayer.h"

NSMutableDictionary * _videoDictionary;
NSMutableArray * _onlineVideoTypeArray;


@implementation SqliteManager {

}

+ (SqliteManager *)sharedSqliteManager {
   static SqliteManager * sqliteManager;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
       sqliteManager = [[SqliteManager alloc] init];
       [sqliteManager resetOnlineVideoTypeArray];
   });

   return sqliteManager;
}


- (NSMutableArray *)getOnlineVideoTypesArray {
   return _onlineVideoTypeArray;
}


- (void)resetOnlineVideoTypeArray {
   _onlineVideoTypeArray = [[MobileDB dbInstance] readOnlineVideoTypes];
   NSString * debug = @"debug";
}


- (void)resetOnlineVideoDictionary {
   _videoDictionary = [[MobileDB dbInstance] readDictionaryForProjectTypeWithProjectTypeId:nil hasAllList:NO];
}


- (NSMutableDictionary *)getCurrentOnlineVideoDictionary:(NSInteger)selectedIndex {
   return _onlineVideoTypeArray[selectedIndex];
}


- (NSMutableDictionary *)getOnlineVideoDictionary {
   return _videoDictionary;
}


- (NSArray *)getProjectTypeArray {
   NSMutableDictionary * dictionary = [self getOnlineVideoDictionary];

   return dictionary.allValues;
}


- (NSMutableArray *)getProjectListArray:(NSString *)projectNameId {

   NSMutableArray * projectLists = [[NSMutableArray alloc] init];
   [[MobileDB dbInstance] readProjectNameLists:[projectNameId intValue] withArray:projectLists isReadArray:YES];

   return projectLists;
}


// Array type is YTYouTubePlayList
- (NSMutableArray *)getAllFileInfoListFromProjectList:(NSMutableArray *)projectLists {
   NSMutableArray * allFileInfoArray = [[NSMutableArray alloc] init];

   for (YTYouTubePlayList * playList in projectLists) {
      for (YTYouTubeVideoCache * videoCache in playList.projectFileInfos) {
//         NSString * fileInforName = videoCache.fileInforName;
//         NSString * debug = @"debug";
         [allFileInfoArray addObject:videoCache];
      }
   }


   return allFileInfoArray;
}


- (NSMutableArray *)getProgressionProjectList:(NSMutableArray *)projectLists {
   return projectLists;
}
@end