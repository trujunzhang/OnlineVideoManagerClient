//
//  Location.h
//  MobileApp
//
//  Created by Aaron Bratcher on 12/06/2012.
//  Copyright (c) 2012 Market Force. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "ABSqliteObject.h"


@interface ABProjectType : ABSqliteObject<MKAnnotation>

@property(assign) int projectTypeID;

// @Muse
@property(copy) NSString * projectTypeName;

@property(strong) NSMutableArray * ProjectNameArray;

- (instancetype)initWithProjectType:(NSString *)projectName;
- (instancetype)initWithProjectTypeID:(int)projectTypeID projectTypeName:(NSString *)projectTypeName;


- (void)appendProjectName:(id)projectName;
@end
