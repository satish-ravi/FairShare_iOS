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

@implementation CreateTripViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
    NSMutableString *text = [[NSMutableString alloc] init];
    Trip *trip = [[Trip alloc] init];
    // we pick up the users from the selection, and create a string that we use to update the text view
    // at the bottom of the display; note that self.selection is a property inherited from our base class
    for (id<FBGraphUser> user in self.friendPickerController.selection) {
        if ([text length]) {
            [text appendString:@", "];
        }
        NSLog(@"%@", user);
        [text appendString:user.name];
    }
    NSLog(@"%@", text);
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
