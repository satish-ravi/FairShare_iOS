//
//  Trip.h
//  fairshare
//
//  Created by Satish Ravi on 7/30/14.
//  Copyright (c) 2014 Satish Ravi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trip : PFObject <PFSubclassing>
+ (NSString *)parseClassName;
@property (retain) NSString *tripName;
@property (retain) NSString *startLocation;
@property (retain) NSString *endLocation;
@property (retain) NSDate *tripDate;
@property double totalCost;
@property (retain) PFUser *createdBy;

@end
