//
//  ExampleViewController.m
//  VideoPlayer
//
//  Created by Amr Abu Zant on 7/25/16.
//  Copyright © 2016 Radix Techs. All rights reserved.
//

#import "ExampleViewController.h"
#import "VideoViewController.h"
@interface ExampleViewController ()
{
    VideoViewController *video;
}

@property (strong, nonatomic) IBOutlet UIView *VideoView;

@end

@implementation ExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSURL *videoPath  = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/VideoPlayer/test.MOV",PROJECT_DIR]];
    
    video = [[VideoViewController alloc] initWithVideoUrl:videoPath];
    video.showSlider = YES;
    video.showPlayButton = YES;
    video.showPopOver = YES;
    
    [self addChildViewController:video];
    
    video.view.size = self.VideoView.size;
    
//    video.canceled = YES;
    [self.view addSubview:self.VideoView];
    [self.VideoView addSubview:video.view];
    
    
    [video didMoveToParentViewController:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [video ChangePlaybuttonimage:@"rangeSliderThumb" and:@"rangeSliderThumb"];
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    
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
