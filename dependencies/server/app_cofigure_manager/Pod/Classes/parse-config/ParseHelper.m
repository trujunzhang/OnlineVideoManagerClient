//
// Created by djzhang on 12/30/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "ParseHelper.h"
#import "OnlineServerInfo.h"
#import <Parse/Parse.h>


@implementation ParseHelper {

}

+ (void)saveOnlineVideoInfo:(OnlineServerInfo *)serverInfo {
   PFObject * gameScore = [PFObject objectWithClassName:@"OnlineServerInfo"];

   gameScore[@"domainHost"] = serverInfo.domainHost;//@"http://192.168.1.103";
   gameScore[@"domainPort"] = serverInfo.domainPort;//@"8040";
   gameScore[@"cacheThumbmail"] = serverInfo.cacheThumbmail;//@"/.cache/thumbnail/";

   [gameScore saveInBackground];
}


+ (void)readOnlineVideoInfo:(ParseHelperResultBlock)parseHelperResultBlock {
   PFQuery * query = [PFQuery queryWithClassName:@"GameScore"];
   [query getObjectInBackgroundWithId:@"xWMyZ4YEGZ" block:^(PFObject * gameScore, NSError * error) {
       // Do something with the returned PFObject in the gameScore variable.
       OnlineServerInfo * onlineServerInfo = [ParseHelper parseInfo:gameScore];
       parseHelperResultBlock(onlineServerInfo, error);
   }];
}


+ (OnlineServerInfo *)parseInfo:(PFObject *)gameScore {
   OnlineServerInfo * serverInfo = [[OnlineServerInfo alloc] init];

   serverInfo.domainHost = gameScore[@"domainHost"];
   serverInfo.domainPort = gameScore[@"domainPort"];
   serverInfo.cacheThumbmail = gameScore[@"cacheThumbmail"];

   return serverInfo;
}


@end