//
//  TripDetailsTableViewCell.h
//  fairshare
//
//  Created by Satish Ravi on 7/31/14.
//  Copyright (c) 2014 Satish Ravi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblCommuter;
@property (weak, nonatomic) IBOutlet UILabel *lblStartLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblEndLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblCost;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UIImageView *imgPicture;

@end
