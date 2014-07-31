//
//  TripDetailsTableViewController.h
//  fairshare
//
//  Created by Satish Ravi on 7/31/14.
//  Copyright (c) 2014 Satish Ravi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripDetailsTableViewController : UITableViewController

@property (nonatomic) Trip* currentTrip;
@property (nonatomic) NSArray *tableData;

@end
