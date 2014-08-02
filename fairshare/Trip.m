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
@dynamic tripName;
@dynamic startLocation;
@dynamic endLocation;
@dynamic tripDate;
@dynamic totalCost;
@dynamic createdBy;
+ (NSString *)parseClassName {
    return @"Trip";
}
+ (void)load {
    @autoreleasepool {
        [self registerSubclass];
    }
}
@end
