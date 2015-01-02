//
// Created by djzhang on 1/2/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import "SqliteArraySortHelper.h"
#import "ABProjectList.h"


@implementation SqliteArraySortHelper {

}

+ (NSArray *)sortForABProjectList:(NSArray *)projectLists {
   NSArray * sortedEmployees = [projectLists sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
       NSString * firstDate = [(ABProjectList *) a projectListName];
       NSString * secondDate = [(ABProjectList *) b projectListName];

       return [firstDate compare:secondDate];
   }];

   return sortedEmployees;
}
@end