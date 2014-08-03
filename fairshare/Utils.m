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
+(PFFile*) getFileObjFromUrlString:(NSString*) urlString fileName:(NSString*) fileName {
    NSURL *userImageURL = [NSURL URLWithString:urlString];
    NSData *userImage = [NSData dataWithContentsOfURL:userImageURL];
    return [PFFile fileWithName:fileName data:userImage];
}
+(PFFile*) getPictureFileFromUserId:(NSString*) userId {
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", userId];
    return [Utils getFileObjFromUrlString:urlString fileName:[NSString stringWithFormat:@"%@.jpg", userId]];
}
+(double) getMilesFromMeters:(double)meters {
    return meters / 1609.34;
}

+(NSString*) getFormattedAddress:(CLPlacemark*) placemark {
    NSDictionary* address = placemark.addressDictionary;
    return (NSString*) [address objectForKey:@"Street"];
}
@end
