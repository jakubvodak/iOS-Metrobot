//
//  MbAppearanceManager.m
//  Metrobot
//
//  Created by Jakub Vodak on 6/29/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import "MbAppearanceManager.h"

@implementation MbAppearanceManager

+ (MbAppearanceManager*)sharedInstance {
    
    static MbAppearanceManager* _sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [MbAppearanceManager new];
    });
    
    return _sharedInstance;
}

- (void)applyAppearance
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    navigationBarAppearance.backgroundColor = [UIColor clearColor];
    [navigationBarAppearance setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    navigationBarAppearance.shadowImage = [[UIImage alloc] init];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [navigationBarAppearance setTitleTextAttributes:attributes];
}

+ (UIColor *)darkBlueColor
{
    return UIColorWithRGBValues(21, 27, 31);
}

@end
