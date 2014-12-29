//
// Created by djzhang on 12/10/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "YTAsFirstVideoRowNode.h"
#import "Foundation.h"
#import "AsyncDisplayKitStatic.h"
#import "MxTabBarManager.h"
#import "YKDirectVideo.h"


@interface YTAsFirstVideoRowNode () {
   ASImageNode * _videoCoverThumbnailsNode;
   YKDirectVideo * _directVideo;
}

@property(nonatomic) CGFloat durationLabelWidth;

@end


@implementation YTAsFirstVideoRowNode {

}


- (void)makeRowNode {
   _videoCoverThumbnailsNode = [[ASImageNode alloc] init];
   _videoCoverThumbnailsNode.contentMode = UIViewContentModeScaleToFill;

   NSString * videoThumbnails = [YoutubeParser getVideoThumbnailsGeneratedFromVideo:self.nodeInfo];
   _directVideo = [[YKDirectVideo alloc] initWithContent:[NSURL URLWithString:videoThumbnails]];
   [_directVideo thumbImage:YKQualityLow completion:^(UIImage * thumbImage, NSError * error) {
       _videoCoverThumbnailsNode.image = thumbImage;
   }];

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
   [_directVideo play:YKQualityLow];
//   [[MxTabBarManager sharedTabBarManager] pushWithVideo:self.nodeInfo];
}

@end