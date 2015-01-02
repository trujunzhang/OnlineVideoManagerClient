//
//  SqliteArraySortHelperTests.m
//  OnlineVideoClient
//
//  Created by djzhang on 1/2/15.
//  Copyright (c) 2015 djzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "SqliteArraySortHelper.h"
#import "ABObjectSortExample.h"


@interface SqliteArraySortHelperTests : XCTestCase

@end


@implementation SqliteArraySortHelperTests

- (void)setUp {
   [super setUp];
   // Put setup code here. This method is called before the invocation of each test method in the class.
}


- (void)tearDown {
   // Put teardown code here. This method is called after the invocation of each test method in the class.
   [super tearDown];
}


- (void)testExample {
   // This is an example of a functional test case.
   NSString * str = @"stack";
   NSMutableArray * charArray = [NSMutableArray arrayWithCapacity:str.length];
   for (int i = 0; i < str.length; ++i) {
      NSString * charStr = [str substringWithRange:NSMakeRange(i, 1)];
      [charArray addObject:charStr];
   }

   [charArray sortUsingComparator:^(NSString * a, NSString * b) {
       return [a compare:b];
   }];

   NSString * debug = @"debug";

}


- (void)testPerformanceExample {
   [ABObjectSortExample getABProjectListSortArray];

}

@end
