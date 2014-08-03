//
//  TripsTableViewController.m
//  fairshare
//
//  Created by Kaviya Nammalwar on 29/07/14.
//  Copyright (c) 2014 Kaviya Nammalwar. All rights reserved.
//

#import "TripsTableViewController.h"
#import "TripTableViewCell.h"
#import "TripDetailsTableViewController.h"

@interface TripsTableViewController ()

@end

@implementation TripsTableViewController
{
    NSArray *tableData;
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
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationItem setHidesBackButton:YES];
    tableData = [NSArray arrayWithObjects:nil, nil];
    
}

- (void)loadData {
    tableData = [NSArray arrayWithObjects:nil, nil];
    [PFCloud callFunctionInBackground:@"getTripByUser"
                       withParameters:@{@"userId": [[PFUser currentUser] objectForKey:USER_FB_ID]}
                                block:^(NSArray *result, NSError *error) {
                                    if (!error) {
                                        tableData = result;
                                        [self.tableView reloadData];
                                    } else {
                                        NSLog(@"Error occured %@", error);
                                    }
                                }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_fromCreate) {
        [self performSegueWithIdentifier:@"tripDetailsSegue" sender:self.view];
    } else {
        NSLog(@"Reloading");
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
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TripTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tripsId"];
    if (cell == nil) {
        cell = [[TripTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tripsId"];
    }
    Trip *trip = [tableData objectAtIndex:indexPath.row];
    cell.lblTripName.text = trip.tripName;
    if (trip.startLocation != NULL && trip.endLocation != NULL) {
        cell.lblLocation.text = [NSString stringWithFormat:@"%@ - %@", trip.startLocation, trip.endLocation];
        cell.backgroundColor = [UIColor clearColor];
    } else {
        cell.lblLocation.text = TRIP_ACTIVE_DISPLAY;
        cell.backgroundColor = [UIColor greenColor];
    }
    cell.lblTripDate.text = [Utils getDateAsStringWithDate:trip.tripDate Format:@"yyyy-MM-dd"];
    return cell;
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"tripDetailsSegue"]) {
        TripDetailsTableViewController *tripDetailsVC = [segue destinationViewController];
        if (_fromCreate) {
            NSLog(@"Trip created. Going to trip details");
            tripDetailsVC.currentTrip = _createdTrip;
            tripDetailsVC.isActive = YES;
            tripDetailsVC.fromCreate = YES;
            tripDetailsVC.currentTripUsers = _createdTripUsers;
            _fromCreate = NO;
        } else {
            NSLog(@"Selected Row: %ld", (long)[self.tableView indexPathForSelectedRow].row);
            TripTableViewCell* cell = (TripTableViewCell*) [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
            tripDetailsVC.isActive = [TRIP_ACTIVE_DISPLAY isEqualToString:cell.lblLocation.text];
            tripDetailsVC.currentTrip = [tableData objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        }
    } else if ([[segue identifier] isEqualToString:@"addTripSegue"]) {
        CreateTripViewController *createVC = [segue destinationViewController];
        createVC.delegate = self;
    }
}

- (void)setCreatedTrip:(Trip *)trip TripUsers:(NSMutableArray*) tripUsers{
    NSLog(@"Setting trip delegate");
    _createdTrip = trip;
    _fromCreate = YES;
    _createdTripUsers = tripUsers;
}

@end
