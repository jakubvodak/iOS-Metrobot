//
//  BigCircleView.m
//  Metrobot
//
//  Created by Jakub Vodak on 7/16/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import "BigCircleView.h"

#define DEGREES_TO_RADIANS(angle) (angle/180.0*M_PI)

@interface BigCircleView ()

@property (nonatomic) BOOL timeShowed;

@end

@implementation BigCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self applyAppearance];
    }
    return self;
}

- (void)applyAppearance
{
    UIImageView *circle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Img-Round-Big"]];
    circle.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:circle];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:circle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:circle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    _timeShowed = true;
    
    _titleLabel = [UILabel new];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameTime] size:80];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.alpha = 0;
    [self addSubview:_titleLabel];
   
    _inStationLabel = [UILabel new];
    _inStationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _inStationLabel.textColor = [UIColor whiteColor];
    _inStationLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameTime] size:40];
    _inStationLabel.backgroundColor = [UIColor clearColor];
    _inStationLabel.textAlignment = NSTextAlignmentCenter;
    _inStationLabel.alpha = 0;
    _inStationLabel.numberOfLines = 2;
    _inStationLabel.text = @"Vlak ve\nstanici";
    [self addSubview:_inStationLabel];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_inStationLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_inStationLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    _routeLabel = [UILabel new];
    _routeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _routeLabel.textColor = [MbAppearanceManager MBBlueColor];
    _routeLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameStrong] size:12];
    _routeLabel.backgroundColor = [UIColor clearColor];
    _routeLabel.textAlignment = NSTextAlignmentCenter;
    _routeLabel.numberOfLines = 2;
    [_routeLabel setPreferredMaxLayoutWidth:200];
    [self addSubview:_routeLabel];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_routeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_routeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    _loader = [UIView new];
    [_loader setBackgroundColor:[MbAppearanceManager MBBlueColor]];
    [_loader setBounds:CGRectMake(0.0f, 0.0f, 5.0f, 5.0f)];
    [_loader setCenter:[self pointAroundCircumferenceFromCenter:self.center withRadius:120.0f andAngle:0.0f]];
    CALayer * l = [_loader layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:2.5];
    [self addSubview:_loader];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(CGRectGetMidX(self.frame) - 120.0f, CGRectGetMidY(self.frame) - 120.0f, 240.0f, 240.0f)];
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.duration = 2.0;
    pathAnimation.repeatCount = HUGE_VALF;
    [pathAnimation setCalculationMode:kCAAnimationPaced];
    pathAnimation.path = [path CGPath];
    
    [_loader.layer addAnimation:pathAnimation forKey:@"curveAnimation"];
    
    _progressView = [DACircularProgressView new];
    _progressView.translatesAutoresizingMaskIntoConstraints = NO;
    _progressView.roundedCorners = YES;
    _progressView.trackTintColor = UIColorWithRGBValues(38, 74, 83);
    _progressView.alpha = 0;
    [circle addSubview:_progressView];
    
    [circle addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-1-[_progressView]-1-|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(_progressView)]];
    [circle addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[_progressView]-1-|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(_progressView)]];
}

- (CGPoint)pointAroundCircumferenceFromCenter:(CGPoint)center withRadius:(CGFloat)radius andAngle:(CGFloat)theta
{
    CGPoint point = CGPointZero;
    point.x = center.x + radius * cosf(theta);
    point.y = center.y + radius * sinf(theta);
    
    return point;
}

- (void)timeFormatted:(NSInteger)totalSeconds
{
    NSInteger seconds;
    NSInteger minutes;
    NSInteger hours;
    
    [self showUpLabel:totalSeconds];
    
    if (totalSeconds>0) {
        seconds = totalSeconds % 60;
        minutes = (totalSeconds / 60) % 60;
        hours = (totalSeconds / 3600);
    }
    else {
        seconds = 0;
        minutes = 0;
        hours = 0;
    }
    
    NSString *secondString;
    
    if (seconds < 10) {
        secondString = [NSString stringWithFormat:@"0%ld", (long)seconds];
    }
    else {
        secondString = [NSString stringWithFormat:@"%ld", (long)seconds];
    }
    
    NSString *minutesString;
    
    if (minutes < 10 && hours > 0) {
        minutesString = [NSString stringWithFormat:@"0%ld", (long)minutes];
    }
    else {
        minutesString = [NSString stringWithFormat:@"%ld", (long)minutes];
    }
    
    if (hours > 0) {
        _titleLabel.text = [NSString stringWithFormat:@"%ld:%@:%@", (long)hours, minutesString, secondString];
        _titleLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameTime] size:60];
    }
    else {
        _titleLabel.text = [NSString stringWithFormat:@"%@:%@", minutesString, secondString];
        _titleLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameTime] size:80];
    }
    
    if (totalSeconds<=300 && totalSeconds>=0) {
        [_progressView setProgress:_progressView.progress-0.000333 animated:YES];
    }
    if (totalSeconds < 0) {
        _progressView.alpha = 0;
    }
}

- (void)showUpLabel:(NSInteger)totalSeconds
{
    if (_titleLabel.alpha == 1 || _inStationLabel.alpha == 1) {
    if (totalSeconds < 0 && _timeShowed) {
        _timeShowed = false;
        [UIView animateWithDuration:0.3 animations:^{
            _titleLabel.alpha = 0;
            _inStationLabel.alpha = 1;
        }];
    }
    else if (totalSeconds > 0 && !_timeShowed) {
        _timeShowed = true;
        [UIView animateWithDuration:0.3 animations:^{
            _titleLabel.alpha = 1;
            _inStationLabel.alpha = 0;
        }];
    }
    }
}


@end
