//
//  BigCircleView.h
//  Metrobot
//
//  Created by Jakub Vodak on 7/16/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"

@interface BigCircleView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *inStationLabel;
@property (nonatomic, strong) UILabel *routeLabel;
@property (nonatomic, strong) DACircularProgressView *progressView;
@property (nonatomic, strong) UIView *loader;

- (void)timeFormatted:(NSInteger)totalSeconds;

@end
