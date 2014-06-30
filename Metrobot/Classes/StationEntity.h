//
//  StationEntity.h
//  Metrobot
//
//  Created by Jakub Vodak on 6/29/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum {
    metroRouteA,
    metroRouteB,
    metroRouteC
} metroRoute;

@interface StationEntity : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSArray *routes;

+ (StationEntity *)initWithName: (NSString *)name metroRoutes: (NSArray *)routes andLocation: (CLLocation *)loc;
+ (NSArray *)setupContent;

@end
