//
//  EntranceEntity.m
//  Metrobot
//
//  Created by Jakub Vodak on 6/29/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import "EntranceEntity.h"

@implementation EntranceEntity

+ (EntranceEntity *)initWithName:(NSString *)name description:(NSString *)description andLocation:(CLLocation *)loc
{
    EntranceEntity *entrance = [EntranceEntity new];
    entrance.name = name;
    entrance.description = description;
    entrance.location = loc;
    return entrance;
}

+ (NSArray *)setupContent
{
    return nil;
}

@end
