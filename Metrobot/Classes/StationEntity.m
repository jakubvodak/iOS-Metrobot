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

+ (NSURL *)prepareURLFrom:(StationEntity *)from To:(StationEntity *)to onTime:(NSString *) time
{
    NSString *urlPath;
    NSString *searchTarget = [self findSecondStationAfter:from onDirection:to];
    
    urlPath = @"http://jizdnirady.idnes.cz/praha/spojeni/?f=";
    urlPath = [urlPath stringByAppendingString:from.name];
    urlPath = [urlPath stringByAppendingString:@"&t="];
    //urlPath = [urlPath stringByAppendingString:[self findSecondStationAfter:departure onDirection:destination]];
    urlPath = [urlPath stringByAppendingString:searchTarget];
    urlPath = [urlPath stringByAppendingString:@"&time="];
    urlPath = [urlPath stringByAppendingString:time];
    urlPath = [urlPath stringByAppendingString:@"&fc=301003&tc=301003&trt=302&direct=false&byarr=false&submit=true&af=true&lng=C"];
    
    urlPath = [[NSString alloc] initWithData:[urlPath dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES] encoding:NSASCIIStringEncoding];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    return [[NSURL alloc] initWithString:urlPath];
}

+ (NSString *)findSecondStationAfter:(StationEntity *)from onDirection:(StationEntity *)to
{
    for (int i=0; i<3; i++) {
        
        NSArray *stations = [StationEntity getStationsForTrace:i];
        if ([stations containsObject:to.name]) {
            if ([[stations objectAtIndex:0] isEqualToString:to.name])
            {
                return [NSString stringWithString: [stations objectAtIndex:[stations indexOfObject:from.name]-1]];
            }
            else if ([[stations objectAtIndex:[stations count]-1] isEqualToString:to.name])
            {
                return [NSString stringWithString: [stations objectAtIndex:[stations indexOfObject:from.name]+1]];
            }
        }
    }

    return @"";
}

@end
