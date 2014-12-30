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

+ (OnlineServerInfo *)standardServerInfo {
   OnlineServerInfo * serverInfo = [[OnlineServerInfo alloc] init];

   serverInfo.domainHost = @"http://192.168.1.103";
   serverInfo.domainPort = @"8040";
   serverInfo.cacheThumbmail = @"/.cache/thumbnail/";

   return serverInfo;
}


- (NSString *)getCurrentDomainUrl {
   return [NSString stringWithFormat:@"%@:%@", self.domainHost, self.domainPort];
}

@end