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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"createSegue"]) {
        TripDetailsTableViewController *tripDetailsVC = [segue destinationViewController];
        tripDetailsVC.currentTrip = trip;
        tripDetailsVC.fromCreate = YES;
        tripDetailsVC.currentTripUsers = [NSArray arrayWithArray:tripUserArr];
    }
}

- (IBAction)chooseFriendsClicked:(UIButton *)sender {
    NSString *tripName = [_txtTripName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([tripName length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Trip Name" message:@"Please enter trip name before choosing friends" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alert show];
    }
    else if (FBSession.activeSession.isOpen) {
        if (self.friendPickerController == nil) {
            // Create friend picker, and get data loaded into it.
            self.friendPickerController = [[FBFriendPickerViewController alloc] init];
            self.friendPickerController.title = @"Pick Friends";
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
    // we pick up the users from the selection, and create a string that we use to update the text view
    // at the bottom of the display; note that self.selection is a property inherited from our base class
    for (id<FBGraphUser> user in self.friendPickerController.selection) {
        TripUser *tripUser = [[TripUser alloc] init];
        tripUser.tripId = trip;
        tripUser.commuterId = [user objectID];
        tripUser.displayName = user.name;
        tripUser.picture = [Utils getPictureFileFromUserId:[user objectID]];
        [tripUserArr addObject:tripUser];
        count++;
    }
    if (count) {
        TripUser *currentUsr = [[TripUser alloc] init];
        currentUsr.tripId = trip;
        currentUsr.commuterId = [[PFUser currentUser] objectForKey:@"fbId"];
        currentUsr.displayName = [[PFUser currentUser] objectForKey:@"displayName"];
        currentUsr.picture = [[PFUser currentUser] objectForKey:@"picture"];
        [tripUserArr addObject:currentUsr];
        NSLog(@"%d friends selected", count);
        [trip saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error && succeeded) {
                for (TripUser *tripUser in tripUserArr) {
                    [tripUser.picture saveInBackground];
                    [tripUser saveInBackground];
                }
                [self dismissViewControllerAnimated:YES completion:NULL];
                [self.delegate setCreatedTrip:trip];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No friends selected" message:@"Please select at least one friend" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alert show];
    }
}

- (void)facebookViewControllerCancelWasPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
