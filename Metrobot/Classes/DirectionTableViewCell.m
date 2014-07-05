//
//  DirectionTableViewCell.m
//  Metrobot
//
//  Created by Jakub Vodak on 7/5/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import "DirectionTableViewCell.h"
#import "UIImage+ImageEffects.h"
#import <math.h>

@implementation DirectionTableViewCell

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
    self.backgroundColor = [UIColor clearColor];
    //self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icn-Disclosure"]];
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[MbAppearanceManager MBBlueColor]]];
    
    UIView *contenView = self.contentView;
    
    UIView *traceView = [UIView new];
    traceView.translatesAutoresizingMaskIntoConstraints = NO;
    [contenView addSubview:traceView];
    
    _roundImageView = [UIImageView new];
    _roundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [traceView addSubview:_roundImageView];
    
    [traceView addConstraint:[NSLayoutConstraint constraintWithItem:_roundImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:traceView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [traceView addConstraint:[NSLayoutConstraint constraintWithItem:_roundImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:traceView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = UIColorWithRGBValues(53, 61, 63);
    [traceView addSubview:_lineView];
    
    _stationLabel = [UILabel new];
    _stationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _stationLabel.textColor = [UIColor whiteColor];
    _stationLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameStrong] size:17];
    _stationLabel.backgroundColor = [UIColor clearColor];
    [contenView addSubview:_stationLabel];
    
    _countLabel = [UILabel new];
    _countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameMedium] size:13];
    _countLabel.backgroundColor = [UIColor clearColor];
    [contenView addSubview:_countLabel];
    
    UIImageView *disclosureView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icn-Disclosure"]];
    disclosureView.translatesAutoresizingMaskIntoConstraints = NO;
    [contenView addSubview:disclosureView];
    
    UIImageView *separatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Img-Separator"]];
    separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    separatorView.alpha = 0.2;
    [contenView addSubview:separatorView];
    
    [contenView addConstraint:[NSLayoutConstraint constraintWithItem:_stationLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contenView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [contenView addConstraint:[NSLayoutConstraint constraintWithItem:_countLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contenView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [contenView addConstraint:[NSLayoutConstraint constraintWithItem:disclosureView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contenView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [contenView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-12-[traceView(9)]-12-[_stationLabel]-8-[_countLabel]-[disclosureView]-12-|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(traceView, _stationLabel, _countLabel, disclosureView)]];
    [contenView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-35-[separatorView]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(separatorView)]];
    [contenView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separatorView]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(separatorView)]];
    [contenView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[traceView]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(traceView)]];
}

- (void)setLineFrameForIndex: (NSInteger)index andCellHeight: (CGFloat)height
{
    self.lineView.frame = CGRectMake(4, fmod(index, 2)?0:height/2+4, 1, height/2-4);
}

@end
