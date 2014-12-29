//
// Created by djzhang on 12/10/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "YTAsFirstChannelRowNode.h"
#import "MxTabBarManager.h"
#import "NSString+URLEncode.h"
#import "YKDirectVideo.h"


@interface YTAsFirstChannelRowNode () {
   ASImageNode * _videoCoverThumbnailsNode;
   YKDirectVideo * _directVideo;
}

@property(nonatomic) CGFloat durationLabelWidth;

@end


@implementation YTAsFirstChannelRowNode {

}


- (void)makeRowNode {
   _videoCoverThumbnailsNode = [[ASImageNode alloc] init];
   NSString * playListThumbnails = [YoutubeParser getPlayListThumbnailsGeneratedFromVideo:self.nodeInfo];

   _directVideo = [[YKDirectVideo alloc] initWithContent:[NSURL URLWithString:playListThumbnails]];
   [_directVideo thumbImage:YKQualityLow completion:^(UIImage * thumbImage, NSError * error) {
       _videoCoverThumbnailsNode.image = thumbImage;
   }];
   _videoCoverThumbnailsNode.contentMode = UIViewContentModeScaleToFill;

   [self addSubnode:_videoCoverThumbnailsNode];

   [self setNodeTappedEvent];

}


- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
   return self.cellRect.size;
}


- (void)layout {
   _videoCoverThumbnailsNode.frame = self.cellRect;

}


#pragma mark -
#pragma mark node tapped event


- (void)setNodeTappedEvent {
   // configure the button
   _videoCoverThumbnailsNode.userInteractionEnabled = YES; // opt into touch handling
   [_videoCoverThumbnailsNode addTarget:self
                                 action:@selector(buttonTapped:)
                       forControlEvents:ASControlNodeEventTouchUpInside];
}


//YTYouTubePlayList
- (void)buttonTapped:(id)buttonTapped {
   [[MxTabBarManager sharedTabBarManager] pushForYouTubePlayList:self.nodeInfo
                                               withPlayListTitle:[YoutubeParser getPlayListTitle:self.nodeInfo]];
}

@end