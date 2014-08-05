//
//  EditTripTableViewController.m
//  fairshare
//
//  Created by Satish Ravi on 7/31/14.
//  Copyright (c) 2014 Satish Ravi. All rights reserved.
//

#import "EditTripTableViewController.h"
#import "EditLocTableViewCell.h"

@interface EditTripTableViewController ()

@end

@implementation EditTripTableViewController {
    long selectedRow;
    CLGeocoder *geocoder;
    NSArray* placemarksList;
    int selectionType;
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
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    selectedRow = -1;
    geocoder = [[CLGeocoder alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectedRow != -1) {
        return [self.currentTripUsers count] + 1;
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedRow != -1) {
        if (indexPath.row <= selectedRow) {
            return [super tableView:tableView cellForRowAtIndexPath:indexPath];
        }
        else if (indexPath.row == selectedRow) {
            UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
            cell.backgroundColor = [UIColor greenColor];
            return cell;
        } else if (indexPath.row == selectedRow + 1) {
            TripUser *tripUser = [self.currentTripUsers objectAtIndex:selectedRow];
            EditLocTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editLocCell"];
            cell.txtStartLocation.text = tripUser.startLocation;
            cell.txtEndLocation.text = tripUser.endLocation;
            return cell;
        } else {
            return [super tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]];
        }
        
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long currentRow = indexPath.row;
    if (selectedRow != -1) {
        if (currentRow == selectedRow + 1 || currentRow == selectedRow) {
            currentRow = -1;
        } else if (currentRow > selectedRow + 1) {
            currentRow--;
        }
    }
    selectedRow = currentRow;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedRow != -1 && indexPath.row == selectedRow + 1) {
        return SELECTED_ROW_HEIGHT;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
- (IBAction)startSearch:(UITextField *)sender {
    NSLog(@"Start Search clicked");
    selectionType = 0;
    [self searchClickedWithField:sender];
}
- (IBAction)endSearch:(UITextField *)sender {
    NSLog(@"End Search clicked");
    selectionType = 1;
    [self searchClickedWithField:sender];
}

-(void) searchClickedWithField: (UITextField*) sender {
    TripDetailsTableViewCell *cell = (TripDetailsTableViewCell*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:selectedRow inSection:0]];
    NSString* compareText;
    if (selectionType == 0) {
        compareText = cell.lblStartLocation.text;
    } else {
        compareText = cell.lblEndLocation.text;
    };
    if (![compareText isEqualToString:sender.text]) {
        NSLog(@"Field changed");
        [geocoder geocodeAddressString:sender.text completionHandler:^(NSArray *placemarks, NSError *error) {
            if (!error) {
                if ([placemarks count] > 0) {
                    placemarksList = placemarks;
                    NSArray* addList = [Utils getAddressesFromPlaceMarkArr:placemarks];
                    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:CHOOSE_ADDRESS delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
                    for (NSString *title in addList) {
                        [popup addButtonWithTitle:title];
                    }
                    [popup addButtonWithTitle:ALERT_CANCEL];
                    popup.cancelButtonIndex = [addList count];
                    [popup showInView:self.view];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_NO_ADDRESS_TITLE message:ALERT_NO_ADDRESS_MESSAGE delegate:nil cancelButtonTitle:nil otherButtonTitles:ALERT_DISMISS, nil];
                    [alert show];
                    [sender becomeFirstResponder];
                }
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_NO_ADDRESS_TITLE message:ALERT_NO_ADDRESS_MESSAGE delegate:nil cancelButtonTitle:nil otherButtonTitles:ALERT_DISMISS, nil];
                [alert show];
                [sender becomeFirstResponder];
            }
        }];
    }
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex < [placemarksList count]) {
        CLPlacemark* placemark = [placemarksList objectAtIndex:buttonIndex];
        NSString* selectedAddress = [Utils getDisplayAddress:placemark];
        PFGeoPoint* selectedGeoPoint = [PFGeoPoint geoPointWithLocation:placemark.location];
        TripUser *selectedUser = [self.currentTripUsers objectAtIndex:selectedRow];
        if (selectionType == 0) {
            selectedUser.startLocation = selectedAddress;
            selectedUser.startLocGeo = selectedGeoPoint;
        } else {
            selectedUser.endLocation = selectedAddress;
            selectedUser.endLocGeo = selectedGeoPoint;
        }
        [selectedUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
