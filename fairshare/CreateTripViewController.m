//
//  CreateTripViewController.m
//  fairshare
//
//  Created by Satish Ravi on 7/31/14.
//  Copyright (c) 2014 Satish Ravi. All rights reserved.
//

#import "CreateTripViewController.h"

@interface CreateTripViewController ()

@end

@implementation CreateTripViewController {
    Trip *trip;
    NSMutableArray *tripUserArr;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"createSegue"]) {
        TripDetailsTableViewController *tripDetailsVC = [segue destinationViewController];
        tripDetailsVC.currentTrip = trip;
        tripDetailsVC.fromCreate = YES;
        tripDetailsVC.currentTripUsers = [NSArray arrayWithArray:tripUserArr];
    }
}*/

- (IBAction)chooseFriendsClicked:(UIButton *)sender {
    NSString *tripName = [_txtTripName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([tripName length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_EMPTY_TRIP_TITLE message:ALERT_EMPTY_TRIP_MESSAGE delegate:nil cancelButtonTitle:nil otherButtonTitles:ALERT_DISMISS, nil];
        [alert show];
    }
    else if (FBSession.activeSession.isOpen) {
        if (self.friendPickerController == nil) {
            // Create friend picker, and get data loaded into it.
            self.friendPickerController = [[FBFriendPickerViewController alloc] init];
            self.friendPickerController.title = PICK_FRIENDS_TITLE;
            self.friendPickerController.delegate = self;
        }
        
        [self.friendPickerController loadData];
        
        [self presentViewController:self.friendPickerController animated:YES completion:nil];
    }
}

- (void)facebookViewControllerDoneWasPressed:(id)sender {
    trip = [[Trip alloc] init];
    trip.tripName = [_txtTripName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    trip.tripDate = [NSDate date];
    trip.createdBy = [PFUser currentUser];
    tripUserArr = [[NSMutableArray alloc] init];
    int count = 0;
    
    for (id<FBGraphUser> user in self.friendPickerController.selection) {
        TripUser *tripUser = [[TripUser alloc] init];
        tripUser.tripId = trip;
        tripUser.commuterId = [user objectID];
        tripUser.displayName = user.name;
        [tripUserArr addObject:tripUser];
        count++;
    }
    if (count) {
        TripUser *currentUsr = [[TripUser alloc] init];
        currentUsr.tripId = trip;
        currentUsr.commuterId = [[PFUser currentUser] objectForKey:USER_FB_ID];
        currentUsr.displayName = [[PFUser currentUser] objectForKey:USER_DISPLAY_NAME];
        [tripUserArr addObject:currentUsr];
        NSLog(@"%d friends selected", count);
        [_activityIndicator startAnimating];
        [trip saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [_activityIndicator stopAnimating];
            if (!error && succeeded) {
                for (TripUser *tripUser in tripUserArr) {
                    [tripUser saveInBackground];
                }
                [self dismissViewControllerAnimated:YES completion:NULL];
                [self.delegate setCreatedTrip:trip TripUsers:tripUserArr];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_NO_FRIENDS_TITLE message:ALERT_NO_FRIENDS_MESSAGE delegate:nil cancelButtonTitle:nil otherButtonTitles:ALERT_DISMISS, nil];
        [alert show];
    }
}

- (void)facebookViewControllerCancelWasPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
