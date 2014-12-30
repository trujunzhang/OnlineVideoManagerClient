//
// Created by djzhang on 12/30/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OnlineServerInfo : NSObject


@property(nonatomic, strong) NSString * domainHost;
@property(nonatomic, strong) NSString * domainPort;
@property(nonatomic, strong) NSString * cacheThumbmail;

- (NSString *)getCurrentDomainUrl;
@end