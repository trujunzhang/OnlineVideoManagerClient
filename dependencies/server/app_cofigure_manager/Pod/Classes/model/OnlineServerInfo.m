//
// Created by djzhang on 12/30/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "OnlineServerInfo.h"


@interface OnlineServerInfo () {

}

@property(nonatomic, strong) NSString * domainUrl;
@end


@implementation OnlineServerInfo {

}


- (NSString *)getCurrentDomainUrl {
   return [NSString stringWithFormat:@"%@:%@", self.domainHost, self.domainPort];
}

@end