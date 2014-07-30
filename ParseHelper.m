//
//  ParseHelper.m
//  fairshare
//
//  Created by Satish Ravi on 7/30/14.
//  Copyright (c) 2014 Satish Ravi. All rights reserved.
//

#import "ParseHelper.h"

@implementation ParseHelper

+ (NSMutableArray *)getTripsOfUser {
    return NULL;
    
}

+ (NSMutableArray *)getTripsFromJson:(NSString *)jsonString {
    NSMutableArray *trips = [[NSMutableArray alloc] init];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:jsonString options:0 error:nil];
    NSLog(@"%lu", (unsigned long)[json count]);
    return trips;
}

@end
