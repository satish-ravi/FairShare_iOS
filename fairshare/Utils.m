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
    return formattedDate;
}
+(PFFile*) getFileObjFromUrlString:(NSString*) urlString fileName:(NSString*) fileName {
    NSURL *userImageURL = [NSURL URLWithString:urlString];
    NSData *userImage = [NSData dataWithContentsOfURL:userImageURL];
    return [PFFile fileWithName:fileName data:userImage];
}
+(double) getMilesFromMeters:(double)meters {
    return meters / 1609.34;
}

+(NSString*) getDisplayAddress:(CLPlacemark*) placemark {
    NSDictionary* address = placemark.addressDictionary;
    return (NSString*) [address objectForKey:@"Street"];
}

+(NSString*) getFullAddress:(CLPlacemark*) placemark {
    NSDictionary* address = placemark.addressDictionary;
    NSArray* addressLines = [address objectForKey:@"FormattedAddressLines"];
    NSString* line1 = [addressLines objectAtIndex:0];
    return [line1 stringByAppendingString:[addressLines objectAtIndex:1]];
}

+(NSArray*) getAddressesFromPlaceMarkArr:(NSArray*) placemarkArr {
    NSMutableArray* addresses = [NSMutableArray array];
    for (CLPlacemark* placeMark in placemarkArr) {
        [addresses addObject:[self getFullAddress:placeMark]];
    }
    return addresses;
}
@end
