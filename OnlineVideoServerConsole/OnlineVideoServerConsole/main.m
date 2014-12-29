//
//  main.m
//  OnlineVideoServerConsole
//
//  Created by djzhang on 12/29/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OnlineVideoStatisticsHelper.h"
#import "MobileDB.h"


void onButtonClicked() {

//   NSString * videoPath = @"/Volumes/XBMC/ShareAFP/Online Tutorial/Video Training/Lynda.com";
   NSString * videoPath = @"/Volumes/macshare/MacPE/Lynda.com";

   NSString * sqliteFoldPath = [NSString stringWithFormat:@"%@/%@", videoPath, @".cache"];
   OnlineVideoStatisticsHelper * onlineVideoStatisticsHelper = [[OnlineVideoStatisticsHelper alloc] initWithOnlinePath:videoPath];

   NSMutableDictionary * projectTypesDictionary = onlineVideoStatisticsHelper.projectTypesDictionary;

   [[MobileDB dbInstance:sqliteFoldPath] saveForProjectTypeDictionary:projectTypesDictionary];
}


int main(int argc, const char * argv[]) {
   @autoreleasepool {
      // insert code here...
      onButtonClicked();

      NSLog(@"Hello, World!");
   }
   return 0;
}


