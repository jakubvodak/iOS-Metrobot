//
//  PersonTableViewCell.m
//  Metrobot
//
//  Created by Jakub Vodak on 8/3/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import "PersonTableViewCell.h"

@implementation PersonTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *contentView = self.contentView;

    _photo = [UIImageView new];
    _photo.translatesAutoresizingMaskIntoConstraints = NO;
    _photo.layer.cornerRadius = 35;
    _photo.layer.masksToBounds = YES;
    [contentView addSubview:_photo];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_photo]" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(_photo)]];
    //[contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-25-[_photo]" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(_photo)]];

    _aboutLabel = [UILabel new];
    _aboutLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _aboutLabel.textColor = [UIColor whiteColor];
    _aboutLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameMedium] size:17];
    _aboutLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:_aboutLabel];
    
    _nameLabel = [UILabel new];
    _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameStrong] size:17];
    _nameLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:_nameLabel];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-25-[_photo(70)]-40-[_aboutLabel]" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(_photo, _aboutLabel)]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-25-[_photo(70)]-40-[_nameLabel]" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(_photo, _nameLabel)]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_aboutLabel][_nameLabel]" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(_aboutLabel, _nameLabel)]];
    
    UIView *separator = [UIView new];
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    separator.backgroundColor = UIColorWithRGBValues(72, 79, 83);
    [contentView addSubview:separator];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-135-[separator]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(separator)]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separator(0.5)]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(separator)]];
 
}

@end
