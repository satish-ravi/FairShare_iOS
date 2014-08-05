//
//  TripDetailsTableViewController.m
//  fairshare
//
//  Created by Satish Ravi on 7/31/14.
//  Copyright (c) 2014 Satish Ravi. All rights reserved.
//

#import "TripDetailsTableViewController.h"

@implementation TripDetailsTableViewController
{
    CLLocationManager *locManager;
    CLGeocoder *geocoder;
    UIBarButtonItem *totalButton;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    locManager = [[CLLocationManager alloc]init];
    geocoder = [[CLGeocoder alloc]init];
    
    totalButton = [[UIBarButtonItem alloc] initWithTitle:BAR_BTN_TOTAL style:UIBarButtonItemStylePlain target:self action:@selector(totalButtonPressed)];
    NSMutableArray *barbuttonItems = [NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
    [barbuttonItems addObject:totalButton];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithArray:barbuttonItems];
    NSLog(@"%@", self.navigationItem.rightBarButtonItems);
    
    NSLog(@"%@", _currentTrip);
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)loadData {
    if (_currentTrip.totalCost != 0) {
        totalButton.title = [NSString stringWithFormat:@"$ %.2f" ,_currentTrip.totalCost];
    }
    NSLog(@"%@", [self.tableView headerViewForSection:1]);
    PFQuery *query = [PFQuery queryWithClassName:[TripUser parseClassName]];
    [query whereKey:TRID_ID equalTo:_currentTrip];
    [query orderByAscending:TRID_USER_DISPLAY_NAME];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _currentTripUsers = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
            [self refreshCurrentTrip];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.lblTripName.text = _currentTrip.tripName;
    if (_fromCreate) {
        _fromCreate = NO;
        // Disable total button because on create, the locations wont be updated.
        totalButton.enabled = NO;
    } else {
        NSLog(@"Fetching");
        [self loadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_currentTripUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TripDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tripDetailsCell"];
    
    // Configure the cell...
    TripUser *tripUser = [_currentTripUsers objectAtIndex:indexPath.row];
    cell.lblCommuter.text = tripUser.displayName;
    cell.lblStartLocation.text = tripUser.startLocation;
    cell.lblEndLocation.text = tripUser.endLocation;
    cell.backgroundColor = [UIColor clearColor];
    if (_isActive) {
        if (cell.lblStartLocation.text == NULL) {
            cell.lblStartLocation.text = TAP_TO_START;
        } else if (cell.lblEndLocation.text == NULL) {
            cell.lblEndLocation.text = TAP_TO_DROP;
            cell.backgroundColor = [UIColor greenColor];
        }
    }
    [cell.imgFBPicture setProfileID:tripUser.commuterId];
    if (tripUser.cost != 0) {
        cell.lblCost.text = [NSString stringWithFormat:@"$ %.2f", tripUser.cost];
    }
    if (tripUser.distance != 0) {
        cell.lblDistance.text = [NSString stringWithFormat:@"%.2f miles", [Utils getMilesFromMeters:tripUser.distance]];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    locManager.delegate =self;
    locManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    TripDetailsTableViewCell *cell = (TripDetailsTableViewCell*) [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Start: %@", cell.lblStartLocation.text);
    NSLog(@"End: %@", cell.lblEndLocation.text);
    if ([TAP_TO_START isEqualToString:cell.lblStartLocation.text] || [TAP_TO_DROP isEqualToString:cell.lblEndLocation.text]) {
        [locManager startUpdatingLocation];
    }
    
}
-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error:%@", error);
    NSLog(@"Failed to get location!");
    [manager stopUpdatingLocation];
}
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"Location: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    if(currentLocation != nil) {
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if(error==nil && [placemarks count]>0){
                NSString* address = [Utils getDisplayAddress:[placemarks lastObject]];
                NSIndexPath *indexPath =[self.tableView indexPathForSelectedRow];
                TripUser *tripUser = [_currentTripUsers objectAtIndex:indexPath.row];
                TripDetailsTableViewCell *cell = (TripDetailsTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath];
                if ([TAP_TO_START isEqualToString:cell.lblStartLocation.text]) {
                    tripUser.startLocGeo =[PFGeoPoint geoPointWithLocation:newLocation];
                    tripUser.startLocation = address;
                    [tripUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        [self refreshCurrentTrip];
                        [self.tableView reloadData];
                    }];
                    
                }
                if ([TAP_TO_DROP isEqualToString:cell.lblEndLocation.text]) {
                    tripUser.endLocGeo =[PFGeoPoint geoPointWithLocation:newLocation];
                    tripUser.endLocation = address;
                    [tripUser saveInBackground];
                    [tripUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        [tripUser fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                            [_currentTripUsers replaceObjectAtIndex:indexPath.row withObject:object];
                            [self refreshCurrentTrip];
                            [self.tableView reloadData];
                        }];
                    }];
                }
                
            }
            else{
                NSLog(@"%@", error.debugDescription);
            }
            
        }];
        [manager stopUpdatingLocation];
        
    }
}

- (void) refreshCurrentTrip {
    [_currentTrip fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        _currentTrip = (Trip*) object;
        if (_currentTrip.startLocation != NULL && _currentTrip.endLocation != NULL) {
            _isActive = NO;
            totalButton.enabled = YES;
        } else {
            totalButton.enabled = NO;
        }
    }];
}


- (void)totalButtonPressed {
    NSLog(@"Total button pressed");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TOTAL_TITLE message:ALERT_TOTAL_MESSAGE delegate:self cancelButtonTitle:ALERT_CANCEL otherButtonTitles:ALERT_CONFIRM, nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *txtTotal = [alert textFieldAtIndex:0];
    txtTotal.keyboardType = UIKeyboardTypeDecimalPad;
    txtTotal.text = [NSString stringWithFormat:@"%.2f", _currentTrip.totalCost];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index =%ld",(long)buttonIndex);
    if (buttonIndex == 0)
    {
        NSLog(@"You have clicked Cancel");
    }
    else if(buttonIndex == 1)
    {
        UITextField *txtTotal = [alertView textFieldAtIndex:0];
        double total = [txtTotal.text doubleValue];
        NSLog(@"Entered total: %f", total);
        _currentTrip.totalCost = total;
        [_currentTrip saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self loadData];
        }];
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TripDetailsTableViewController *tripDetailsVC = [segue destinationViewController];
    tripDetailsVC.currentTrip = _currentTrip;
}

@end
