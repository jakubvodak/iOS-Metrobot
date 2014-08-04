//
//  SmallCircleView.h
//  Metrobot
//
//  Created by Jakub Vodak on 8/3/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmallCircleView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIActivityIndicatorView *loader;

- (void)timeFormatted:(NSInteger)totalSeconds;

@end
