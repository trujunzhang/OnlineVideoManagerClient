//
// Created by djzhang on 12/30/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "ParseHelper.h"
#import "OnlineServerInfo.h"
#import <Parse/Parse.h>
#import <Bolts/BFTask.h>


@implementation ParseHelper {

}

+ (ParseHelper *)sharedParseHelper {
   static ParseHelper * cache;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
       cache = [[ParseHelper alloc] init];
   });

   return cache;
}


#pragma mark -
#pragma mark Saving Objects to parse Server


- (void)saveOnlineVideoInfo:(OnlineServerInfo *)serverInfo {
   PFObject * gameScore = [PFObject objectWithClassName:@"OnlineServerInfo"];

   gameScore[@"domainHost"] = serverInfo.domainHost;//@"http://192.168.1.103";
   gameScore[@"domainPort"] = serverInfo.domainPort;//@"8040";
   gameScore[@"cacheThumbmail"] = serverInfo.cacheThumbmail;//@"/.cache/thumbnail/";

   [gameScore saveInBackground];
}


#pragma mark -
#pragma mark Fetching Objects to parse Server


- (void)readOnlineVideoInfo:(ParseHelperResultBlock)parseHelperResultBlock {
   PFQuery * query = [PFQuery queryWithClassName:@"OnlineServerInfo"];
   [query getObjectInBackgroundWithId:@"xWMyZ4YEGZ" block:^(PFObject * gameScore, NSError * error) {
       // Do something with the returned PFObject in the gameScore variable.
       OnlineServerInfo * onlineServerInfo = [self parseInfo:gameScore];
       parseHelperResultBlock(onlineServerInfo, error);
   }];
}


- (OnlineServerInfo *)parseInfo:(PFObject *)gameScore {
   OnlineServerInfo * serverInfo = [[OnlineServerInfo alloc] init];

   serverInfo.domainHost = gameScore[@"domainHost"];
   serverInfo.domainPort = gameScore[@"domainPort"];
   serverInfo.cacheThumbmail = gameScore[@"cacheThumbmail"];

   return serverInfo;
}


#pragma mark -
#pragma mark The Local Datastore


- (void)saveLocalVideoInfo:(OnlineServerInfo *)serverInfo {
   PFObject * gameScore = [PFObject objectWithClassName:@"OnlineServerInfo"];

   gameScore[@"domainHost"] = serverInfo.domainHost;//@"http://192.168.1.103";
   gameScore[@"domainPort"] = serverInfo.domainPort;//@"8040";
   gameScore[@"cacheThumbmail"] = serverInfo.cacheThumbmail;//@"/.cache/thumbnail/";

   [gameScore pinInBackground];//The Local Datastore
}


#pragma mark -
#pragma mark Retrieving Objects from the Local Datastore


- (void)readLocalVideoInfo:(ParseHelperResultBlock)parseHelperResultBlock {
   PFQuery * query = [PFQuery queryWithClassName:@"OnlineServerInfo"];
   [query fromLocalDatastore];

   BFTask * bfTask = [query getObjectInBackgroundWithId:@"xWMyZ4YEGZ"];

   BFContinuationBlock continueWithBlock = ^id(BFTask * task) {
       if (task.error) {
          // something went wrong;
          return task;
       }

       // task.result will be your game score
       return task;
   };
   [bfTask continueWithBlock:continueWithBlock];

}

@end