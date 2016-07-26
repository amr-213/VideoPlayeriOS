//
//  RETrimPopover.m
//  RETrimControlExample
//
//  Created by Roman Efimov on 1/23/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RETrimPopover.h"

@implementation RETrimPopover

- (id)initWithFrame:(CGRect)frame :(int)side
{
    return [self initWithFrame:frame resourceBundle:@"RETrimControl.bundle" :side];
}

- (id)initWithFrame:(CGRect)frame resourceBundle:(NSString *)resourceBundle :(int)side
{
    self = [super initWithFrame:frame];
    if (self) {
        //        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@/Popover", resourceBundle]]];
        _image = [[UIImageView alloc]initWithFrame:CGRectMake(15, -15, 10, 50)];
        
        if(side == 1){
            [_image setImage:[UIImage imageNamed:@"end_mark_icon.png"]];
        }else
            [_image setImage:[UIImage imageNamed:@"start_mark_icon.png"]];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -30, 40, 10)];
        _timeLabel.font = [UIFont boldSystemFontOfSize:10];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_timeLabel];
        [self addSubview:_image];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:_timeLabel
                             attribute:NSLayoutAttributeBottom
                             relatedBy:NSLayoutRelationEqual
                             toItem:_image
                             attribute:NSLayoutAttributeTop
                             multiplier:1.0
                             constant:0.0]];
        
        
        self.alpha = 0;
    }
    return self;
}

@end
