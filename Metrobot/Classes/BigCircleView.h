//
//  BigCircleView.h
//  Metrobot
//
//  Created by Jakub Vodak on 7/16/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigCircleView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *routeLabel;

- (void)showTime;

@end
