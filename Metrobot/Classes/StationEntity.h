//
//  StationEntity.h
//  Metrobot
//
//  Created by Jakub Vodak on 6/29/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import "BaseEntity.h"
#import <MapKit/MapKit.h>

@interface StationEntity : BaseEntity

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lng;

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic) CLLocationDistance distance;
@property (nonatomic) NSInteger trace;

+ (NSArray *)getStationsForTrace: (NSInteger)trace;
+ (NSString *)roundImageNameForTrace: (NSInteger)trace;

@end
