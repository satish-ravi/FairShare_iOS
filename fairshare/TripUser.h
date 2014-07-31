//
//  TripUser.h
//  fairshare
//
//  Created by Satish Ravi on 7/31/14.
//  Copyright (c) 2014 Satish Ravi. All rights reserved.
//

#import <Parse/Parse.h>

@interface TripUser : PFObject <PFSubclassing>
+ (NSString *)parseClassName;
@property (retain) Trip *tripId;
@property (retain) NSString *commuterId;
@property (retain) NSString *startLocation;
@property (retain) NSString *endLocation;
@property double cost;
@property double distance;

@end
