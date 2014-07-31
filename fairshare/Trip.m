//
//  Trip.m
//  fairshare
//
//  Created by Satish Ravi on 7/30/14.
//  Copyright (c) 2014 Satish Ravi. All rights reserved.
//

#import "Trip.h"
#import <Parse/PFObject+Subclass.h>

@implementation Trip
@dynamic trip_name;
@dynamic start_location;
@dynamic end_location;
@dynamic tripDate;
@dynamic totalCost;
+ (NSString *)parseClassName {
    return @"Trip";
}
+ (void)load {
    @autoreleasepool {
        [self registerSubclass];
    }
}
@end
