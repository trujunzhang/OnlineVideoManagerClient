//
// Created by djzhang on 1/4/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VideoGenerateSqliteHelper : NSObject


+ (void)generateSqliteFromSourcenWithTypeName:(NSString *)name withLocalPath:(NSString *)path withScanFolder:(NSString *)folder saveSqlitTo:(NSString *)to;
@end