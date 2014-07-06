//
//  SearchTableViewCell.m
//  Metrobot
//
//  Created by Jakub Vodak on 7/6/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "UIImage+ImageEffects.h"

@implementation SearchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self applyAppearance];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)applyAppearance
{
    UIView *contentView = self.contentView;
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[MbAppearanceManager MBBlueColor]]];
    self.backgroundColor = [UIColor clearColor];
    
    _nameLabel = [UILabel new];
    _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameStrong] size:17];
    _nameLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:_nameLabel];
    
    _circleView = [UIImageView new];
    _circleView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:_circleView];
    
    _routeLabel = [UILabel new];
    _routeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _routeLabel.textColor = [UIColor whiteColor];
    _routeLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameMedium] size:13];
    _routeLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:_routeLabel];
    
    UIImageView *disclosureView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icn-Disclosure"]];
    disclosureView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:disclosureView];
    
    UIImageView *separatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Img-Separator"]];
    separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    separatorView.alpha = 0.2;
    [contentView addSubview:separatorView];
    
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:_circleView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:_routeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:disclosureView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_nameLabel]->=0-[_circleView]-8-[_routeLabel]-[disclosureView]-12-|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(_nameLabel, _circleView, _routeLabel, disclosureView)]];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[separatorView]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(separatorView)]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separatorView]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(separatorView)]];
}

@end
