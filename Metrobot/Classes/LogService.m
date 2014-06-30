//
//  LogService.m
//  Metrobot
//
//  Created by Jakub Vodak on 6/29/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import "LogService.h"
#import "Flurry.h"

@implementation LogService

+ (LogService*)sharedInstance {
    
    static LogService* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [LogService new];
    });
    
    return sharedInstance;
}

- (void)logError:(NSError *)error {
    
    NSParameterAssert(error);
    
    NSLog(@"%@", error);
    
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        return;
    }
    
    [Flurry logError:@"API Error" message:error.localizedDescription error:error];
}

@end
