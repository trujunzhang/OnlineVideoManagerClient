//
// Created by djzhang on 12/30/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ParseLocalStore : NSObject
+ (void)saveSqliteVersion:(NSString *)version;
+ (void)readSqliteVersion:(NSString *)version;
+ (BOOL)checkLocalCacheSqliteExist;
@end