//
//  TripDetailsTableViewController.m
//  fairshare
//
//  Created by Satish Ravi on 7/31/14.
//  Copyright (c) 2014 Satish Ravi. All rights reserved.
//

#import "TripDetailsTableViewController.h"
#import "TripDetailsTableViewCell.h"

@implementation TripDetailsTableViewController

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
    
    NSLog(@"%@", _currentTrip);
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)loadData {
    PFQuery *query = [PFQuery queryWithClassName:[TripUser parseClassName]];
    [query whereKey:@"tripId" equalTo:_currentTrip];
    [query orderByAscending:@"displayName"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _currentTripUsers = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_fromCreate) {
        _fromCreate = NO;
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
    if (_isActive) {
        if (cell.lblStartLocation.text == NULL) {
            cell.lblStartLocation.text = TAP_TO_START;
        } else if (cell.lblEndLocation.text == NULL) {
            cell.lblEndLocation.text = TAP_TO_DROP;
        }
    }
    cell.imgPicture.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[tripUser.picture url]]]];
    if (tripUser.cost != 0) {
        cell.lblCost.text = [NSString stringWithFormat:@"$ %.2f", tripUser.cost];
    }
    if (tripUser.distance != 0) {
        cell.lblDistance.text = [NSString stringWithFormat:@"%.2f miles", [Utils getMilesFromMeters:tripUser.distance]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TripDetailsTableViewCell *cell = (TripDetailsTableViewCell*) [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Tapped: %@", indexPath);
    NSLog(@"Start: %@", cell.lblStartLocation.text);
    NSLog(@"End: %@", cell.lblEndLocation.text);
    TripUser *tripUser = [_currentTripUsers objectAtIndex:indexPath.row];
    if ([TAP_TO_START isEqualToString:cell.lblStartLocation.text]) {
        tripUser.startLocGeo =[PFGeoPoint geoPointWithLatitude:40.4528419 longitude:-79.9113629];
        tripUser.startLocation = @"201 Conover Road";
        [tripUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [tableView reloadData];
        }];
        
    }
    if ([TAP_TO_DROP isEqualToString:cell.lblEndLocation.text]) {
        tripUser.endLocGeo =[PFGeoPoint geoPointWithLatitude:40.4455908 longitude:-79.9492398];
        tripUser.endLocation = @"300 S Craig Street";
        [tripUser saveInBackground];
        [tripUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [tripUser fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                [_currentTripUsers replaceObjectAtIndex:indexPath.row withObject:object];
                [tableView reloadData];
            }];
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
