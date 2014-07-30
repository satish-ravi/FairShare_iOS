//
//  TripTableViewCell.h
//  fairshare
//
//  Created by Satish Ravi on 7/30/14.
//  Copyright (c) 2014 Satish Ravi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTripName;
@property (weak, nonatomic) IBOutlet UILabel *lblTripDate;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;

@end
