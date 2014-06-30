//
//  EntranceEntity.h
//  Metrobot
//
//  Created by Jakub Vodak on 6/29/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StationEntity.h"
#import <MapKit/MapKit.h>

@interface EntranceEntity : StationEntity

@property (nonatomic, strong) NSString *description;

+ (EntranceEntity *)initWithName: (NSString *)name description: (NSString *)description andLocation: (CLLocation *)loc;
+ (NSArray *)setupContent;

@end
