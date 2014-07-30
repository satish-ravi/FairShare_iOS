//
//  ParseHelper.h
//  fairshare
//
//  Created by Satish Ravi on 7/30/14.
//  Copyright (c) 2014 Satish Ravi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trip.h"

@interface ParseHelper : NSObject

+ (NSMutableArray*) getTripsOfUser;
+ (NSMutableArray*) getTripsFromJson:(NSString *)jsonString;

@end
