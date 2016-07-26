//
//  VideoViewController.h
//  VideoPlayer
//
//  Created by Amr Abu Zant on 7/25/16.
//  Copyright © 2016 Radix Techs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewUtils.h"
#import <AVkit/AVPlayerViewController.h>
#import "MARKRangeSlider.h"

@import AVFoundation;

@interface VideoViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *videoView;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIView *sliderView;

@property (strong, nonatomic) NSURL *videoUrl;
@property (strong, nonatomic) AVPlayer *avPlayer;
@property (strong, nonatomic) AVPlayerLayer *avPlayerLayer;
@property (strong, nonatomic) AVPlayerViewController *playerController;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) AVAsset *asset;
@property (strong, nonatomic) MARKRangeSlider *rangeSlider;
@property (assign, nonatomic) CGFloat startTime;
@property (assign, nonatomic) CGFloat stopTime;
@property (nonatomic, assign) BOOL canceled;
@property (nonatomic, assign) BOOL showSlider;
@property (nonatomic, assign) BOOL showPlayButton;
@property (nonatomic, assign) BOOL showPopOver;
@property (nonatomic, assign) BOOL AutoPlay;

@property (assign, nonatomic) CGFloat videoPlaybackPosition;

- (IBAction)PlayPressed:(id)sender;
- (void)play;
- (void)pause;
- (instancetype)initWithVideoUrl:(NSURL *)url;
- (void)SetVideoSize:(CGSize)size;
- (void)SetSliderColor:(UIColor*) sliderColor;
- (void)ChangePlaybuttonimage:(NSString*)pauseImageName and:(NSString*)playImageName;
@end
