//
//  LogService.m
//  Metrobot
//
//  Created by Jakub Vodak on 6/29/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import "LogService.h"

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
    
    //[Flurry logError:@"API Error" message:error.localizedDescription error:error];
    
    [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
}

@end
