//
//  DirectionsTableView.m
//  Metrobot
//
//  Created by Jakub Vodak on 7/1/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import "DirectionsTableView.h"

@implementation DirectionsTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self applyAppearance];
    }
    return self;
}

- (void)applyAppearance
{
    self.backgroundColor = [UIColor clearColor];
    self.showsVerticalScrollIndicator = NO;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self registerClass:[DirectionTableViewCell class] forCellReuseIdentifier:@"DirectionCell"];
}

@end
