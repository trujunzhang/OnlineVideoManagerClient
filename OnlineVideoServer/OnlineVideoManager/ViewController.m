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
#import "ABProjectType.h"


@implementation ViewController

- (void)viewDidLoad {
   [super viewDidLoad];

   [self.refreshButton setTarget:self];
   [self.refreshButton setAction:@selector(onButtonClicked:)];

   self.videoPath.stringValue =
    @"/Volumes/XBMC/ShareAFP/Online Tutorial/Video Training/Lynda.com";
   //@"/Volumes/macshare/MacPE/Lynda.com";

   // Insert code here to initialize your application

   expertise = [[NSMutableDictionary alloc] init];
   [expertise setObject:[NSArray arrayWithObjects:@"Expert", @"Moderate", @"Novice", nil] forKey:@"John123"];
//   [expertise setObject:[NSArray arrayWithObjects:@"Moderate", @"Expert", @"Expert", nil] forKey:@"Micheal"];
//   [expertise setObject:[NSArray arrayWithObjects:@"Expert", @"Novice", @"Expert", nil] forKey:@"Gerald"];

   self.videoTableView.dataSource = self;
   self.videoTableView.delegate = self;
}


- (void)onButtonClicked:(id)onButtonClicked {

   NSString * onlinePath = [NSString stringWithFormat:@"%@/%@", self.videoPath.stringValue, @".cache"];
   OnlineVideoStatisticsHelper * onlineVideoStatisticsHelper = [[OnlineVideoStatisticsHelper alloc] initWithOnlinePath:onlinePath];

   self.projectTypesDictionary = onlineVideoStatisticsHelper.projectTypesDictionary;

   [[MobileDB dbInstance:onlinePath] saveForProjectTypeDictionary:self.projectTypesDictionary];

//   [self refreshTableView];
}


- (void)refreshTableView {
//   self.projectTypesDictionary;
   expertise = [ABProjectType getAllProjectNames:self.projectTypesDictionary];
   [self.videoTableView reloadData];
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
