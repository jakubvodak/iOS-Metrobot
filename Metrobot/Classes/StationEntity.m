//
//  StationEntity.m
//  Metrobot
//
//  Created by Jakub Vodak on 6/29/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import "StationEntity.h"

@implementation StationEntity

+ (NSArray *)getStationsForTrace: (NSInteger)trace
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"metroStations" ofType:@"plist"];
    NSDictionary *dictComplete = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    switch (trace) {
        case 0:
            return [dictComplete valueForKey:@"TraceA"];
            break;
        case 1:
            return [dictComplete valueForKey:@"TraceB"];
            break;
        case 2:
            return [dictComplete valueForKey:@"TraceC"];
            break;
        default:
            return nil;
            break;
    }
}

+ (NSString *)roundImageNameForTrace: (NSInteger)trace
{
    switch (trace) {
        case 0:
            return @"Icn-Round-Green";
            break;
        case 1:
            return @"Icn-Round-Yellow";
            break;
        case 2:
            return @"Icn-Round-Red";
            break;
        default:
            return nil;
            break;
    }
}

@end
