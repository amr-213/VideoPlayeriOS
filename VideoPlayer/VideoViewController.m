//
//  VideoViewController.m
//  VideoPlayer
//
//  Created by Amr Abu Zant on 7/25/16.
//  Copyright © 2016 Radix Techs. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()
{
    CGFloat screenWidth;
    CGFloat screenHeight;
    float seconds;
    CMTime duration;
    NSString* pauseName;
    NSString* playName;
    
}
@end

@implementation VideoViewController

- (instancetype)initWithVideoUrl:(NSURL *)url {
    self = [super init];
    if(self) {
        _videoUrl = url;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    /////Setting Default Play/Pause Buttons //////
    playName = @"buttons_0000_Layer-3-copy.png";
    pauseName = @"buttons_0001_Layer-1.png";
    /////////////////////////////////////////////
    
    NSURL *videoPath = _videoUrl;
    //Temp Video URL Testing On THE Simulator Only
    //    NSURL *videoPath  = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/VideoPlayer/test.MOV",PROJECT_DIR]];
    NSLog(@"%@",videoPath);
    //////////////
    
    //////// Get Screen Diminions //////////
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    ///////////////////////////////////////
    
    
    ///// the video player init. /////
    
    self.asset = [AVAsset assetWithURL:videoPath];
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:self.asset];
    
    self.avPlayer = [AVPlayer playerWithPlayerItem:item];
    
    _playerController = [AVPlayerViewController alloc];
    _playerController.showsPlaybackControls = NO;
    [_playerController setPlayer:self.avPlayer];
    
    self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    //    self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    //        self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avPlayer currentItem]];
    
    //    self.avPlayerLayer.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
    
    
    [self.videoView addSubview:self.playerController.view];
    [self.playerController setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    
    [self.playerController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    [self.videoView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    
    __weak VideoViewController *weakSelf = self;
    [self.avPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0 / 60.0, NSEC_PER_SEC)
                                                queue:NULL
                                           usingBlock:^(CMTime time){
                                               [weakSelf updateProgressBar];
                                           }];
    /////////////////////////////////////////////////////////////////////////
    
    
    ///////////////////////Calculate The Time ////////////////////
    duration = self.asset.duration;
    seconds = CMTimeGetSeconds(duration);
    NSLog(@"duration: %.2f", seconds);
    //////////////////////////////////////////////////////////////
    
    
    ////// Video Track Init. ///////////
    
    self.rangeSlider = [[MARKRangeSlider alloc] initWithFrame :CGRectZero];
    [self.rangeSlider addTarget:self
                         action:@selector(rangeSliderValueDidChange:)
               forControlEvents:UIControlEventValueChanged];
    
    [self.rangeSlider setMinValue:0.0 maxValue:seconds];
    [self.rangeSlider setLeftValue:0.0 rightValue:seconds];
    [self.rangeSlider setLeftThumbImage:nil];
    self.rangeSlider.minimumDistance = 0;
    
    [self SetSliderColor:[UIColor colorWithRed:255/255. green:85./255. blue: 112./255. alpha:1.]];
    
    [self.sliderView addSubview:self.rangeSlider];
    /////////////////////////////////////////
    
    
    ////// Setting Some Options ///////////
    
    if (!self.showPopOver) {
        [self.rangeSlider RemovePopOver];
    }
    
    if (self.showSlider) {
        [self.videoView addSubview:self.sliderView];
    }
    if(self.showPlayButton){
        [self.videoView addSubview:self.playButton];
    }
    
    //////////////////////////////////////
    
    [self ApplyConstraints];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self SetAutoPlay];
    
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.rangeSlider.frame = CGRectMake(0, (self.sliderView.height/2)-10 , self.sliderView.width, 20.0);
    [self.playerItem seekToTime:kCMTimeZero];
}

- (void)rangeSliderValueDidChange:(MARKRangeSlider *)slider {
    //    NSLog(@"%0.2f - %0.2f", self.rangeSlider.leftValue, self.rangeSlider.rightValue);
    
    if (self.rangeSlider.rightValue != self.startTime) {
        //then it moved the left position, we should rearrange the bar
        [self seekVideoToPos:self.rangeSlider.rightValue];
    }
    self.startTime = self.rangeSlider.rightValue;
}

- (void)updateProgressBar
{
    
    //    NSLog(@" UpDate Progress Bar Activated ");
    
    //    NSLog(@" Time  = %f / %f",self.avPlayer.currentTime.value,_playerItem.duration.value);
    
    double time = CMTimeGetSeconds(self.avPlayer.currentTime);
    //    self.progressBar.progress = (CGFloat) (time / seconds);
    //    NSLog(@"%f",(CGFloat) (time));
    [self.rangeSlider setLeftValue:0 rightValue:(CGFloat) (time)];
}

-(void)SetSliderColor:(UIColor*) sliderColor{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [sliderColor CGColor]) ;
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.rangeSlider setRangeImage:img];
}

- (void)SetVideoSize:(CGSize)size{
    
    [self.playerController.view setFrame:CGRectMake(0, 0,size.width,size.height)];
    
}


- (void)seekVideoToPos:(CGFloat)pos
{
    self.videoPlaybackPosition = pos;
    CMTime time = CMTimeMakeWithSeconds(self.videoPlaybackPosition, self.avPlayer.currentTime.timescale);
    [self.avPlayer seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
    [self PlayPressed:nil];
    
}


-(void)play{
    [self.avPlayer play];
    [self.playButton setImage:[UIImage imageNamed:playName] forState:UIControlStateNormal];
}
-(void)pause{
    [self.avPlayer pause];
    [self.playButton setImage:[UIImage imageNamed:pauseName] forState:UIControlStateNormal];
}


- (IBAction)PlayPressed:(id)sender {
    NSLog(@"Play button Pressed in Video View");
    if(self.avPlayer.rate) {
        [self pause];
    }else{
        [self play];
    }
}

-(void)ChangePlaybuttonimage:(NSString *)pauseImageName and:(NSString *)playImageName{
    pauseName = pauseImageName;
    playName = playImageName;
}

-(void)SetAutoPlay{
    
    if(self.AutoPlay){
        [self play];
    }else{
        [self pause];
    }
    
}

-(void)ApplyConstraints{
    
    NSDictionary *viewsDictionary = @{@"Video":self.videoView, @"Slider":self.rangeSlider, @"Player":self.playerController.view};
    
    NSArray *constraint_Player_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[Player]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:viewsDictionary];
    NSArray *constraint_Player_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[Player]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:viewsDictionary];
    [self.videoView addConstraints:constraint_Player_V];
    [self.videoView addConstraints:constraint_Player_H];
    
    //    [self.view addConstraint:[NSLayoutConstraint
    //                                  constraintWithItem:self.rangeSlider
    //                                  attribute:NSLayoutAttributeCenterX
    //                                  relatedBy:NSLayoutRelationEqual
    //                                  toItem:self.sliderView
    //                                  attribute:NSLayoutAttributeCenterX
    //                                  multiplier:1.0
    //                                  constant:0.0]];
    //    
    //    [self.dumyView addConstraint:[NSLayoutConstraint
    //                                  constraintWithItem:self.rangeSlider
    //                                  attribute:NSLayoutAttributeCenterY
    //                                  relatedBy:NSLayoutRelationEqual
    //                                  toItem:self.sliderView
    //                                  attribute:NSLayoutAttributeCenterY
    //                                  multiplier:1.0
    //                                  constant:-2.0]];
    
    //    [self.dumyView addConstraint:[NSLayoutConstraint
    //                              constraintWithItem:self.playerController.view
    //                              attribute:NSLayoutAttributeWidth
    //                              relatedBy:NSLayoutRelationEqual
    //                              toItem:self.videoView
    //                              attribute:NSLayoutAttributeWidth
    //                              multiplier:1.0
    //                              constant:0.0]];
    //
    //    [self.dumyView addConstraint:[NSLayoutConstraint
    //                              constraintWithItem:self.playerController.view
    //                              attribute:NSLayoutAttributeHeight
    //                              relatedBy:NSLayoutRelationEqual
    //                              toItem:self.videoView
    //                              attribute:NSLayoutAttributeHeight
    //                              multiplier:1.0
    //                              constant:0.0]];
    
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
