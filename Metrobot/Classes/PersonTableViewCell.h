//
//  PersonTableViewCell.h
//  Metrobot
//
//  Created by Jakub Vodak on 8/3/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) UILabel *aboutLabel;
@property (nonatomic, strong) UILabel *nameLabel;

@end
