//
// Created by djzhang on 1/4/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import <media_sqlite_manager/MobileDB.h>
#import <media_logical_layer/OnlineVideoStatisticsHelper.h>
#import "VideoGenerateSqliteHelper.h"


@implementation VideoGenerateSqliteHelper {

}
+ (void)generateSqliteFromSourcenWithTypeName:(NSString *)onlineTypeName withLocalPath:(NSString *)onlineVideoTypePath withScanFolder:(NSString *)videoScanFold saveSqlitTo:(NSString *)dbDirectory {

   // 1
   OnlineVideoStatisticsHelper * onlineVideoStatisticsHelper = [[OnlineVideoStatisticsHelper alloc] initWithOnlinePath:videoScanFold
                                                                                                    withCacheDirectory:dbDirectory];

   // 2
   [[MobileDB dbInstance:dbDirectory] saveForOnlineVideoTypeDictionary:onlineVideoStatisticsHelper.projectTypesDictionary
                                                              withName:onlineTypeName
                                              whithOnlineVideoTypePath:onlineVideoTypePath
   ];
}
@end