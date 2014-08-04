//
//  TripDetailsTableViewController.h
//  fairshare
//
//  Created by Satish Ravi on 7/31/14.
//  Copyright (c) 2014 Satish Ravi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripDetailsTableViewCell.h"

@interface TripDetailsTableViewController : UITableViewController <UIAlertViewDelegate, CLLocationManagerDelegate>

@property (nonatomic) Trip* currentTrip;
@property (nonatomic) NSMutableArray *currentTripUsers;
@property (nonatomic) BOOL fromCreate;
@property (nonatomic) BOOL isActive;
@property (weak, nonatomic) IBOutlet UILabel *lblTripName;
-(void) loadData;

@end
