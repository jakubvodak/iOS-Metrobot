//
//  NextDeparturesView.m
//  Metrobot
//
//  Created by Jakub Vodak on 8/3/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import "NextDeparturesView.h"

@implementation NextDeparturesView

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
    UIView *centerView = [UIView new];
    centerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:centerView];
    
    UIView *titleView = [UIView new];
    titleView.translatesAutoresizingMaskIntoConstraints = NO;
    [centerView addSubview:titleView];
    
    UIImageView *nextIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icn-Title-Next"]];
    nextIcon.translatesAutoresizingMaskIntoConstraints = NO;
    [titleView addSubview:nextIcon];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameMedium] size:17];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"Další odjezdy";
    [titleView addSubview:titleLabel];
    
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[nextIcon]-5-[titleLabel]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(nextIcon, titleLabel)]];
    [titleView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:titleView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [titleView addConstraint:[NSLayoutConstraint constraintWithItem:nextIcon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:titleView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    UIView *circlesView = [UIView new];
    circlesView.translatesAutoresizingMaskIntoConstraints = NO;
    [centerView addSubview:circlesView];
    
    _circle1 = [SmallCircleView new];
    _circle1.translatesAutoresizingMaskIntoConstraints = NO;
    [circlesView addSubview:_circle1];
    
    _circle2 = [SmallCircleView new];
    _circle2.translatesAutoresizingMaskIntoConstraints = NO;
    [circlesView addSubview:_circle2];
    
    _circle3 = [SmallCircleView new];
    _circle3.translatesAutoresizingMaskIntoConstraints = NO;
    _circle3.nextButton.hidden = NO;
    [circlesView addSubview:_circle3];
    
    [circlesView addConstraint:[NSLayoutConstraint constraintWithItem:_circle1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:circlesView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [circlesView addConstraint:[NSLayoutConstraint constraintWithItem:_circle2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:circlesView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [circlesView addConstraint:[NSLayoutConstraint constraintWithItem:_circle3 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:circlesView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [circlesView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_circle1]-30-[_circle2]-30-[_circle3]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(_circle1, _circle2, _circle3)]];
    
    [centerView addConstraint:[NSLayoutConstraint constraintWithItem:titleView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:centerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [centerView addConstraint:[NSLayoutConstraint constraintWithItem:circlesView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:centerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    if ([[UIScreen mainScreen] bounds].size.height<=480) {
        titleView.hidden = YES;
        [centerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[circlesView(65)]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(circlesView)]];
    }
    else {
        [centerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleView(28)]-20-[circlesView(65)]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(titleView, circlesView)]];
    }
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[centerView]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(centerView)]];
}

@end
