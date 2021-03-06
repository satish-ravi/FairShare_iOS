//
//  ViewController.m
//  fairshare
//
//  Created by Kaviya Nammalwar on 29/07/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "LoginViewController.h"
#import "TripsTableViewController.h"

@interface LoginViewController ()

@end
@implementation LoginViewController
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
	if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        NSLog(@"User logged in already");
        
        [self performSegueWithIdentifier:@"tripsSegue" sender:self.view];
        
    }
    
}
- (IBAction)loginClicked:(id)sender {
    
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    [_activityIndicator startAnimating];
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_LOGIN_CANCEL_TITLE message:ALERT_LOGIN_CANCEL_MESSAGE delegate:nil cancelButtonTitle:nil otherButtonTitles:ALERT_DISMISS, nil];
                [alert show];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_LOGIN_ERROR_TITLE message:ALERT_LOGIN_CANCEL_MESSAGE delegate:nil cancelButtonTitle:nil otherButtonTitles:ALERT_DISMISS, nil];
                [alert show];
            }
        }
        
        else
        {
            NSLog(@"FB ID: %@", [user objectForKey:USER_FB_ID]);
            if ([user objectForKey:USER_FB_ID] == NULL || [user objectForKey:USER_DISPLAY_NAME] == NULL) {
                
                NSLog(@"Retrieving facebook id and name");
                [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        NSString *userId = [result objectID];
                        NSLog(@"Results: %@", result);
                        // Store the current user's Facebook ID on the user
                        [user setObject:userId forKey:USER_FB_ID];
                        [user setObject:[result objectForKey:@"name"] forKey:USER_DISPLAY_NAME];
                        [user saveInBackground];
                        NSLog(@"Saved fbid, name, file");
                        [self performSegueWithIdentifier:@"tripsSegue" sender:self.view];
                        
                    }
                }];
            } else {
                NSLog(@"User logged in");
                [self performSegueWithIdentifier:@"tripsSegue" sender:self.view];
                
            }
        }
        
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
