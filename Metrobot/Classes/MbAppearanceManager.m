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
    navigationBarAppearance.tintColor = [MbAppearanceManager MBBlueColor];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:[MbAppearanceManager fontNameLight] size:17], NSFontAttributeName,nil];
    [navigationBarAppearance setTitleTextAttributes:attributes];
    
}

+ (UIColor *)MBBlueColor
{
    return UIColorWithRGBValues(25, 221, 255);
}

+ (UIColor *)MBDarkBlueColor
{
    return UIColorWithRGBValues(21, 27, 31);
}

+ (NSString *)fontNameLight
{
    return @"MuseoSans-100";
}

+ (NSString *)fontNameMedium
{
    return @"MuseoSans-300";
}

+ (NSString *)fontNameStrong
{
    return @"MuseoSans-500";
}

@end
