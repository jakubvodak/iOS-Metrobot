//
//  StationTitleView.h
//  Metrobot
//
//  Created by Jakub Vodak on 7/4/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationTitleView : UIView

@property (nonatomic, strong) UILabel *stationName;
@property (nonatomic, strong) UILabel *distanceLabel;

- (void)checkTitleSize;

@end
