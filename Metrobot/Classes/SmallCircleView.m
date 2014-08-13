//
//  SmallCircleView.m
//  Metrobot
//
//  Created by Jakub Vodak on 8/3/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import "SmallCircleView.h"

@implementation SmallCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self applyAppearance];
    }
    return self;
}

- (void)applyAppearance
{
    UIImageView *bgCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Img-Round-Small"]];
    bgCircle.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:bgCircle];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[bgCircle]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(bgCircle)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bgCircle]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(bgCircle)]];
    
    _titleLabel = [UILabel new];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameMedium] size:18];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.alpha = 0;
    _titleLabel.numberOfLines = 2;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    _nextButton.hidden = YES;
    _nextButton.alpha = 0;
    [_nextButton setImage:[UIImage imageNamed:@"Icn-Next-Departures"] forState:UIControlStateNormal];
    [self addSubview:_nextButton];
    
    _loader = [UIActivityIndicatorView new];
    _loader.translatesAutoresizingMaskIntoConstraints = NO;
    _loader.color = [MbAppearanceManager MBBlueColor];
    _loader.hidesWhenStopped = true;
    _loader.alpha = 0;
    [self addSubview:_loader];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nextButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.03 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nextButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_loader attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_loader attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void)timeFormatted:(NSInteger)totalSeconds
{
    int time;
    NSString *timeString;
    NSRange range;
    
    if (totalSeconds>3600) {
        time = (totalSeconds/3600.0);
        timeString = [NSString stringWithFormat:@"%d\nhod", time];
        range = [timeString rangeOfString: @"hod"];
    }
    else {
        if (totalSeconds>0) {
            time = (totalSeconds / 60.0);
        }
        else {
            time = 0;
        }
        
        timeString = [NSString stringWithFormat:@"%d\nmin", time];
        range = [timeString rangeOfString: @"min"];
    }
    
    NSMutableAttributedString *topAttrString = [[NSMutableAttributedString alloc] initWithString: timeString];
    [topAttrString addAttribute: NSFontAttributeName
                          value: [UIFont fontWithName:[MbAppearanceManager fontNameMedium] size:11]
                          range: range];
    
    
    self.titleLabel.attributedText = topAttrString;
}

@end
