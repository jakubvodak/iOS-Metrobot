//
//  SearchTableViewController.h
//  Metrobot
//
//  Created by Jakub Vodak on 7/6/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationEntity.h"

@interface SearchTableViewController : UITableViewController

@property (nonatomic, copy) void (^finishBlock)(StationEntity *station);

@end
