//
//  TimeEntity.m
//  Metrobot
//
//  Created by Jakub Vodak on 7/19/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import "TimeEntity.h"

@implementation TimeEntity

+ (NSString *)getNextDepartureTime: (NSTimeInterval)addTime
{
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"HH:mm"];
    
    NSDateFormatter *dfsec = [NSDateFormatter new];
    [dfsec setDateFormat:@"s"];
    
    NSDate *actualDate = [NSDate date];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *second = [f numberFromString:[dfsec stringFromDate:actualDate]];
    
    if (addTime > 0) {
        NSDate *nextDepartureTime = [actualDate dateByAddingTimeInterval:addTime];
        return [df stringFromDate:nextDepartureTime];
    }
    else if ([second integerValue] < 15)
    {
        return [df stringFromDate:actualDate];
    }
    
    NSTimeInterval secondsInMin = 60;
    NSDate *nextDepartureTime = [actualDate dateByAddingTimeInterval:secondsInMin];
    
    return [df stringFromDate:nextDepartureTime];
}

+ (NSNumber *)countRemainingTime:(NSString *)departure
{
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"HH:mm:ss"];
    
    NSDate *actualDate = [NSDate date];
    NSString *dateString = [df stringFromDate:actualDate];
    
    NSTimeInterval timeDifference =[[df dateFromString:departure] timeIntervalSinceDate:[df dateFromString:dateString]];
    
    if (timeDifference < -50000)
    {
        timeDifference+=86400;
    }
    
    return @(timeDifference);
}

- (void)parseHtml:(NSString *)htmlString
{
    NSString *result;
    
    NSRange divRange;
    NSRange endDivRange;
    NSRange tempRange;
    
    _regularDepartures = [NSMutableArray new];
    
    for (int i=0; i<3; i++)
    {
        divRange = [htmlString rangeOfString:@"<th class=\"time w6p\">" options:NSCaseInsensitiveSearch];
        
        if (divRange.location != NSNotFound)
        {
            endDivRange.location = divRange.length + divRange.location;
            endDivRange.length   = [htmlString length] - endDivRange.location;
            endDivRange = [htmlString rangeOfString:@"</th>" options:NSCaseInsensitiveSearch range:endDivRange];
            
            if (endDivRange.location != NSNotFound)
            {
                divRange.location += divRange.length;
                divRange.length = endDivRange.location - divRange.location;
                
                result = [htmlString substringWithRange:divRange];
                
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDate *now = [NSDate date];
                NSDateComponents *components = [gregorian components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:now];
                NSDateFormatter* df = [[NSDateFormatter alloc]init];
                [df setDateFormat:@"yyyy-MM-dd"];
                
                NSDateFormatter *mmddccyy = [[NSDateFormatter alloc] init];
                mmddccyy.timeStyle = NSDateFormatterNoStyle;
                mmddccyy.dateFormat = @"yyyy-MM-dd HH:mm";
                NSDate *d = [mmddccyy dateFromString:[NSString stringWithFormat:@"%@ %@", [df stringFromDate:[gregorian dateFromComponents:components]], result]];
                
                
                [_regularDepartures addObject: d];
            }
        }
        else
        {
            break;
        }
        
        tempRange.location = endDivRange.location;
        tempRange.length = [htmlString length] - endDivRange.location;
        htmlString = [htmlString substringWithRange:tempRange];
    }
}

@end
