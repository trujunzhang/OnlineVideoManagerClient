//
// Created by djzhang on 12/29/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "Online_Request.h"


@implementation Online_Request {

}


+ (Online_Request *)sharedInstance {
   static Online_Request * _sharedClient = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
       NSURL * baseURL = [NSURL URLWithString:@"http://192.168.1.103:8040/"];

       NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
       [config setHTTPAdditionalHeaders:@{ @"User-Agent" : @"APIs-Google" }];

       NSURLCache * cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                          diskCapacity:50 * 1024 * 1024
                                                              diskPath:nil];

       [config setURLCache:cache];

       _sharedClient = [[Online_Request alloc] initWithBaseURL:baseURL
                                          sessionConfiguration:config];
       _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];

   });

   return _sharedClient;
}

@end