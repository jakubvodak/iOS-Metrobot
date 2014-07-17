//
//  TimeViewController.h
//  Metrobot
//
//  Created by Jakub Vodak on 6/29/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationEntity.h"

@interface TimeViewController : UIViewController

@property (nonatomic, strong) StationEntity *currentStation;
@property (nonatomic, strong) StationEntity *destinationStation;

@end
