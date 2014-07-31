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
    [PFCloud callFunctionInBackground:@"getTripByUser"
                       withParameters:@{@"userId": @"user1"}
                                block:^(NSArray *result, NSError *error) {
                                    if (!error) {
                                        tableData = result;
                                        [self.tableView reloadData];
                                    } else {
                                        
                                    }
                                }];
    
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
    NSLog(@"Trip:%@", trip);
    cell.lblTripName.text = trip.trip_name;
    cell.lblLocation.text = [NSString stringWithFormat:@"%@ - %@", trip.start_location, trip.end_location];
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
        NSLog(@"Selected Row: %ld", (long)[self.tableView indexPathForSelectedRow].row);
        tripDetailsVC.currentTrip = [tableData objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}

@end
