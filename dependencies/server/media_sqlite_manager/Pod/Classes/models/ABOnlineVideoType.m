//
// Created by djzhang on 12/31/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "ABOnlineVideoType.h"
#import "ABProjectType.h"
#import "MobileDB.h"


@implementation ABOnlineVideoType {

}


- (instancetype)init {
   self = [super init];
   if (self) {
      self.onlineVideoTypeID = [MobileDB uniqueID];
      self.onlineNameArray = [[NSMutableArray alloc] init];
   }

   return self;
}


- (instancetype)initWithOnlineTypeName:(NSString *)onlineTypeName OnlineVideoTypePath:(NSString *)OnlineVideoTypePath {
   self = [self init];
   if (self) {
      self.onlineTypeName = onlineTypeName;
      self.OnlineVideoTypePath = OnlineVideoTypePath;
   }

   return self;
}


- (void)appendProjectType:(ABProjectType *)projectType {
   [self.onlineNameArray addObject:projectType];
}


#pragma mark -
#pragma mark ABSqliteObject


- (NSMutableDictionary *)getUpdateDictionary {
   NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
   [dictionary setObject:self.onlineTypeName forKey:@"onlineTypeName"];
   [dictionary setObject:self.OnlineVideoTypePath forKey:@"OnlineVideoTypePath"];

   return dictionary;
}


- (NSMutableDictionary *)getInsertDictionary {

   return [self getUpdateDictionary];
}


@end