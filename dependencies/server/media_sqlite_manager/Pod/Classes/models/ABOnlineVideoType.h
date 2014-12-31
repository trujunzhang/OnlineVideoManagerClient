//
// Created by djzhang on 12/31/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABSqliteObject.h"


@interface ABOnlineVideoType : ABSqliteObject

@property(assign) int onlineTypeID;
@property(copy) NSString * onlineTypeName;
@property(copy) NSString * OnlineVideoTypePath;

@property(strong) NSMutableArray * onlineNameArray;
- (instancetype)initWithOnlineTypeName:(NSString *)onlineTypeName OnlineVideoTypePath:(NSString *)OnlineVideoTypePath;


@end