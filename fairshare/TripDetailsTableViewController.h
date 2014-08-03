//
//  TripDetailsTableViewController.h
//  fairshare
//
//  Created by Satish Ravi on 7/31/14.
//  Copyright (c) 2014 Satish Ravi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripDetailsTableViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic) Trip* currentTrip;
@property (nonatomic) NSMutableArray *currentTripUsers;
@property (nonatomic) BOOL fromCreate;
@property (nonatomic) BOOL isActive;

@end
