//
//  ViewController.m
//  OnlineVideoManager
//
//  Created by djzhang on 12/26/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import "ViewController.h"
#import "CustomTable.h"
#import "OnlineVideoStatisticsHelper.h"
#import "MobileDB.h"


@implementation ViewController

- (void)viewDidLoad {
   [super viewDidLoad];

   [self.refreshButton setTarget:self];
   [self.refreshButton setAction:@selector(onButtonClicked:)];

   self.videoPath.stringValue = @"/Volumes/macshare/MacPE/Lynda.com";

   // Insert code here to initialize your application

   expertise = [[NSMutableDictionary alloc] init];
   [expertise setObject:[NSArray arrayWithObjects:@"Expert", @"Moderate", @"Novice", nil] forKey:@"John"];
   [expertise setObject:[NSArray arrayWithObjects:@"Moderate", @"Expert", @"Expert", nil] forKey:@"Micheal"];
   [expertise setObject:[NSArray arrayWithObjects:@"Expert", @"Novice", @"Expert", nil] forKey:@"Gerald"];

   self.videoTableView.dataSource = self;
   self.videoTableView.delegate = self;

   NSString * onlinePath = self.videoPath.stringValue;
   OnlineVideoStatisticsHelper * onlineVideoStatisticsHelper = [[OnlineVideoStatisticsHelper alloc] initWithOnlinePath:onlinePath];

   self.projectsDictionary = onlineVideoStatisticsHelper.projectsDictionary;

   [[MobileDB dbInstance:onlinePath] saveForProjectTypeDictionary:self.projectsDictionary];

   [[MobileDB dbInstance:onlinePath] readDictionaryForProjectType];


}


- (void)onButtonClicked:(id)onButtonClicked {

}


- (void)setRepresentedObject:(id)representedObject {
   [super setRepresentedObject:representedObject];

   // Update the view, if already loaded.
}


#pragma mark -
#pragma mark NSTableViewDataSource


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
   return [[expertise allKeys] count];
}


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
   NSString * key = [[expertise allKeys] objectAtIndex:row];
   NSInteger column = [[tableColumn identifier] intValue];
   if (column == 0)
      return key;
   return [[expertise valueForKey:key] objectAtIndex:column - 1];
}


- (void)tableView:(NSTableView *)aTableView
   setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)aTableColumn
              row:(NSInteger)rowIndex {

}


@end
