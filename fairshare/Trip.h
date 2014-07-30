//
//  Trip.h
//  fairshare
//
//  Created by Satish Ravi on 7/30/14.
//  Copyright (c) 2014 Satish Ravi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trip : NSObject

@property (retain, nonatomic) NSString *tripName;
@property (retain, nonatomic) NSString *startLocation;
@property (retain, nonatomic) NSString *endLocation;
@property (nonatomic) double totalCost;

@end
