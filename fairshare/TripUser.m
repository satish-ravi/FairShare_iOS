//
//  TripUser.m
//  fairshare
//
//  Created by Satish Ravi on 7/31/14.
//  Copyright (c) 2014 Satish Ravi. All rights reserved.
//

#import "TripUser.h"
#import <Parse/PFObject+Subclass.h>

@implementation TripUser
@dynamic commuterId;
@dynamic startLocation;
@dynamic endLocation;
@dynamic cost;
@dynamic distance;
@dynamic tripId;
@dynamic displayName;
@dynamic startLocGeo;
@dynamic endLocGeo;
@dynamic picture;
+ (NSString *)parseClassName {
    return @"TripUser";
}
+ (void)load {
    @autoreleasepool {
        [self registerSubclass];
    }
}
@end
