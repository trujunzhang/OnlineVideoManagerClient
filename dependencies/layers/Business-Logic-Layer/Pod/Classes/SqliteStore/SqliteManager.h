//
// Created by djzhang on 12/27/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SqliteManager : NSObject

+ (void)saveSqliteFileAfterFetchingFromServer;


+ (SqliteManager *)sharedSqliteManager;
- (NSMutableDictionary *)getOnlineVideoDictionary;

- (NSArray *)getProjectTypeArray;

- (void)resetOnlineVideoDictionary;

- (NSMutableArray *)getProjectListArray:(NSString *)projectNameId;
- (NSMutableArray *)getAllFileInfoListFromProjectList:(NSMutableArray *)projectLists;
- (NSMutableArray *)getProgressionProjectList:(NSMutableArray *)projectLists;
@end