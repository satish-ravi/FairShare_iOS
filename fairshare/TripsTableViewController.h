//
//  TripsTableViewController.h
//  fairshare
//
//  Created by Kaviya Nammalwar on 29/07/14.
//  Copyright (c) 2014 Kaviya Nammalwar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateTripViewController.h"

@interface TripsTableViewController : UITableViewController <CreateTripViewControllerDelegate>

@property (nonatomic) BOOL fromCreate;
@property (nonatomic) Trip *createdTrip;

@end
