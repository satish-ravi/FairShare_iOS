//
//  Utils.m
//  fairshare
//
//  Created by Satish Ravi on 7/31/14.
//  Copyright (c) 2014 Satish Ravi. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+(NSString*) getDateAsStringWithDate:(NSDate*) date Format:(NSString*) format {
    NSString* formattedDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    formattedDate = [formatter stringFromDate:date];
    NSLog(@"Date: %@", formattedDate);
    return formattedDate;
}
@end
