//
//  Utils.h
//  fairshare
//
//  Created by Satish Ravi on 7/31/14.
//  Copyright (c) 2014 Satish Ravi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
+(NSString*) getDateAsStringWithDate:(NSDate*) date Format:(NSString*) format;
+(PFFile*) getFileObjFromUrlString:(NSString*) urlString fileName:(NSString*) fileName;
+(PFFile*) getPictureFileFromUserId:(NSString*) userId;
+(double) getMilesFromMeters:(double) meters;
+(NSString*) getFormattedAddress:(CLPlacemark*) placemark;

@end
