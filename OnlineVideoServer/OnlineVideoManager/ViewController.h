//
//  ViewController.h
//  OnlineVideoManager
//
//  Created by djzhang on 12/26/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class CustomTable;


@interface ViewController : NSViewController<NSTableViewDelegate, NSTableViewDataSource> {
   NSMutableDictionary * expertise;
}

@property(strong) IBOutlet NSTextFieldCell * videoPath;
@property(strong) IBOutlet NSButtonCell * refreshButton;

@property(strong) IBOutlet CustomTable * videoTableView;

@property(nonatomic, strong) NSMutableDictionary * projectsDictionary;
@end

