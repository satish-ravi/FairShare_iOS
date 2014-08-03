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
	// Do any additional setup after loading the view, typically from a nib.
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        NSLog(@"User logged in already");
        [self performSegueWithIdentifier:@"tripsSegue" sender:self.view];
        
    }
    
}
- (IBAction)loginClicked:(id)sender {
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        // [_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        }
        
        else
        {
            NSLog(@"FB ID: %@", [user objectForKey:USER_FB_ID]);
            if ([user objectForKey:USER_FB_ID] == NULL || [user objectForKey:USER_DISPLAY_NAME] == NULL || [user objectForKey:USER_PICTURE] == NULL) {
                NSLog(@"Retrieving facebook id and name");
                [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        NSString *userId = [result objectID];
                        NSLog(@"Results: %@", result);
                        PFFile *file = [Utils getPictureFileFromUserId:userId];
                        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (!error) {
                                // Store the current user's Facebook ID on the user
                                [user setObject:userId forKey:USER_FB_ID];
                                [user setObject:[result objectForKey:@"name"] forKey:USER_DISPLAY_NAME];
                                [user setObject:file forKey:USER_PICTURE];
                                [user saveInBackground];
                                NSLog(@"Saved fbid, name, file");
                                [self performSegueWithIdentifier:@"tripsSegue" sender:self.view];
                            } else {
                                NSLog(@"Error when saving file");
                            }
                        }];
                    }
                }];
            } else {
                NSLog(@"User logged in");
                [self performSegueWithIdentifier:@"tripsSegue" sender:self.view];
            }
        }
        
        
        
        //else if (user.isNew) {
        //  NSLog(@"User with facebook signed up and logged in!");
        //[self performSegueWithIdentifier:@"tripsSegue" sender:self.view];
        //        } else {
        //          NSLog(@"User with facebook logged in!");
        //        [self performSegueWithIdentifier:@"tripsSegue" sender:self.view];
        //  }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
