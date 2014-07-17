//
//  StationTitleView.m
//  Metrobot
//
//  Created by Jakub Vodak on 7/4/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import "StationTitleView.h"

#define defaultTitleFont [UIFont fontWithName:[MbAppearanceManager fontNameStrong] size:39]

@implementation StationTitleView

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
    UIView *contentView = [UIView new];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:contentView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    UIView *topView = [UIView new];
    topView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:topView];
    
    UIView *bottomView = [UIView new];
    bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:bottomView];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topView]-10-[bottomView]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(topView, bottomView)]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[topView]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(topView)]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[bottomView]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(bottomView)]];
    
    _stationName = [UIButton new];
    _stationName.translatesAutoresizingMaskIntoConstraints = NO;
    _stationName.titleLabel.textColor = [UIColor whiteColor];
    [_stationName setTitleColor:[MbAppearanceManager MBBlueColor] forState:UIControlStateHighlighted];
    _stationName.titleLabel.font = defaultTitleFont;
    _stationName.backgroundColor = [UIColor clearColor];
    [topView addSubview:_stationName];
    
    [topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_stationName]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(_stationName)]];
    [topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_stationName]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(_stationName)]];
    
    UIView *bottomCenterView = [UIView new];
    bottomCenterView.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomView addSubview:bottomCenterView];
    
    UIImageView *pinView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icn-Pin"]];
    pinView.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomCenterView addSubview:pinView];
    
    _distanceLabel = [UILabel new];
    _distanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _distanceLabel.textColor = [UIColor whiteColor];
    _distanceLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameLight] size:31];
    _distanceLabel.backgroundColor = [UIColor clearColor];
    [bottomCenterView addSubview:_distanceLabel];
    
    [bottomView addConstraint:[NSLayoutConstraint constraintWithItem:bottomCenterView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bottomCenterView]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(bottomCenterView)]];
    
    [bottomCenterView addConstraint:[NSLayoutConstraint constraintWithItem:pinView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:bottomCenterView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [bottomCenterView addConstraint:[NSLayoutConstraint constraintWithItem:_distanceLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:bottomCenterView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [bottomCenterView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[pinView]-8-[_distanceLabel]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(pinView, _distanceLabel)]];
    
}

- (void)checkTitleSize
{
    CGSize textSize = [_stationName.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:defaultTitleFont}];
    
    if (textSize.width > 320) {
        _stationName.titleLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameStrong] size:30];
    }
    else if (textSize.width > 300) {
        _stationName.titleLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameStrong] size:32];
    }
    else {
        _stationName.titleLabel.font = defaultTitleFont;
    }
}

@end
