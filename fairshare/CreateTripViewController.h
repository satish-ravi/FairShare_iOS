//
//  CreateTripViewController.h
//  fairshare
//
//  Created by Satish Ravi on 7/31/14.
//  Copyright (c) 2014 Satish Ravi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateTripViewController : UIViewController <FBViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtTripName;
@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;

@end
