//
//  MbAppearanceManager.h
//  Metrobot
//
//  Created by Jakub Vodak on 6/29/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MbAppearanceManager : NSObject

+ (MbAppearanceManager*)sharedInstance;

- (void)applyAppearance;

+ (UIColor *)darkBlueColor;

@end
