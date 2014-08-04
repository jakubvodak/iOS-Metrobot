//
//  TimeEntity.h
//  Metrobot
//
//  Created by Jakub Vodak on 7/19/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeEntity : NSObject

@property (nonatomic, strong) NSMutableArray *regularDepartures;

+ (NSString *)getNextDepartureTime: (NSTimeInterval)addTime;
+ (NSNumber *)countRemainingTime:(NSString *)departure;

- (void)parseHtml: (NSString *)htmlString;

@end
