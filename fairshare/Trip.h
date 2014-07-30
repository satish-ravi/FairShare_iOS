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
@property (retain) NSString *trip_name;
@property (retain) NSString *start_location;
@property (retain) NSString *end_location;

@end
