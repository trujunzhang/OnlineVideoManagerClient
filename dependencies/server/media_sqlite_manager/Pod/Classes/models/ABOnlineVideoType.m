//
// Created by djzhang on 12/31/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "ABOnlineVideoType.h"
#import "ABProjectType.h"


@implementation ABOnlineVideoType {

}


- (void)appendProjectType:(ABProjectType *)projectType {
   [self.onlineNameArray addObject:projectType];
}

@end