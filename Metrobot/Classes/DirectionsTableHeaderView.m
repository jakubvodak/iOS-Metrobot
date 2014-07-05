//
//  DirectionsTableHeaderView.m
//  Metrobot
//
//  Created by Jakub Vodak on 7/2/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import "DirectionsTableHeaderView.h"

@implementation DirectionsTableHeaderView

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
    self.backgroundColor = UIColorWithRGBValues(38, 52, 59);
    
    UIView *centerView = [UIView new];
    centerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:centerView];
    
    UIImageView *arrowsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icn-Table-Header-Arrows"]];
    arrowsImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [centerView addSubview:arrowsImageView];
    
    _titleLabel = [UIButton new];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_titleLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _titleLabel.titleLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameMedium] size:13];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [_titleLabel setTitle:@"VYBERTE SMĚR" forState:UIControlStateNormal];
    [centerView addSubview:_titleLabel];
    
    [centerView addConstraint:[NSLayoutConstraint constraintWithItem:arrowsImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:centerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [centerView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:centerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [centerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[arrowsImageView]-[_titleLabel]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(arrowsImageView, _titleLabel)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[centerView]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(centerView)]];
}

@end
