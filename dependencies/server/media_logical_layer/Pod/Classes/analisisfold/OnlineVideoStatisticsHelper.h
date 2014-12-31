//
// Created by djzhang on 12/26/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OnlineVideoStatisticsHelper : NSObject

@property(nonatomic, strong) NSString * onlinePath;
@property(nonatomic, copy) NSString * onlineTypeName;

@property(nonatomic, strong) NSMutableDictionary * projectTypesDictionary;

- (instancetype)initWithOnlinePath:(NSString *)onlinePath withName:(NSString *)name;

@end