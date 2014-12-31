//
// Created by djzhang on 12/31/14.
//

#import <Foundation/Foundation.h>
@protocol ABDatabase;

id<ABDatabase> db;


@interface MobileBaseDatabase : NSObject {

}


+ (NSString *)uniqueID;
- (void)makeDB;
- (void)checkSchema;

@end