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

@property (nonatomic, strong) UIView *loader;

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
    circle.alpha = 0.2;
    [self addSubview:circle];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:circle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:circle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    _titleLabel = [UILabel new];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameMedium] size:70];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = @"3:21";
    _titleLabel.alpha = 0;
    [self addSubview:_titleLabel];
   
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    _routeLabel = [UILabel new];
    _routeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _routeLabel.textColor = [MbAppearanceManager MBBlueColor];
    _routeLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameMedium] size:14];
    _routeLabel.backgroundColor = [UIColor clearColor];
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
}

- (CGPoint)pointAroundCircumferenceFromCenter:(CGPoint)center withRadius:(CGFloat)radius andAngle:(CGFloat)theta
{
    CGPoint point = CGPointZero;
    point.x = center.x + radius * cosf(theta);
    point.y = center.y + radius * sinf(theta);
    
    return point;
}

- (void)showTime
{
    //self.titleLabel.transform = CGAffineTransformMakeScale(0, 0);
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    
        //self.titleLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.titleLabel.alpha = 1;
        
        
        self.routeLabel.frame = CGRectMake(self.routeLabel.frame.origin.x,
                                           self.routeLabel.frame.origin.y+50,
                                           self.routeLabel.frame.size.width,
                                           self.routeLabel.frame.size.height);
        self.loader.alpha = 0;
        
    } completion:^(BOOL finished){
        [_loader.layer removeAllAnimations];
    }];
    
    
    
}



@end
