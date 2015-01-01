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
//      self.onlineTypeArray = [[NSMutableArray alloc] init];
      self.onlineTypeDictionary = [[NSMutableDictionary alloc] init];
   }

   return self;
}


- (instancetype)initWithOnlineTypeName:(NSString *)onlineTypeName OnlineVideoTypePath:(NSString *)OnlineVideoTypePath {
   self = [self init];
   if (self) {
      self.onlineVideoTypeName = onlineTypeName;
      self.OnlineVideoTypePath = OnlineVideoTypePath;
   }

   return self;
}


- (void)appendProjectTypeDictionary:(NSMutableDictionary *)dictionary {
   for (ABProjectType * projectType in dictionary.allValues) {
      [self appendProjectType:projectType];
   }
}


- (void)appendProjectType:(ABProjectType *)projectType {
   [self.onlineTypeArray addObject:projectType];
}


#pragma mark -
#pragma mark ABSqliteObject


- (NSMutableDictionary *)getUpdateDictionary {
   NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
   [dictionary setObject:self.onlineVideoTypeName forKey:@"onlineVideoTypeName"];
   [dictionary setObject:self.OnlineVideoTypePath forKey:@"OnlineVideoTypePath"];

   return dictionary;
}


- (NSMutableDictionary *)getInsertDictionary {

   return [self getUpdateDictionary];
}


@end