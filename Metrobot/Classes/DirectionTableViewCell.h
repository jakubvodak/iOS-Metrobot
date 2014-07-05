//
//  DirectionTableViewCell.h
//  Metrobot
//
//  Created by Jakub Vodak on 7/5/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectionTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *roundImageView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *stationLabel;
@property (nonatomic, strong) UILabel *countLabel;

- (void)setLineFrameForIndex: (NSInteger)index andCellHeight: (CGFloat)height;

@end
