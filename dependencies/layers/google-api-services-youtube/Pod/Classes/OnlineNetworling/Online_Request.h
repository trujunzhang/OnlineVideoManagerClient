//
// Created by djzhang on 12/29/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"


@interface Online_Request : AFHTTPSessionManager
+ (Online_Request *)sharedInstance;
@end