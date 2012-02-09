//
//  topicList.m
//  OPin
//
//  Created by John C Hudson on 2/7/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "topicList.h"
#import "AddressAnnotation.h"
#import "tableViewController.h"

@implementation topicList

@synthesize pinAnnotationArray;
@synthesize pastMKUserAnnotation;
@synthesize bgImage;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self removeMyLocation];
    //[[self navigationController] setToolbarHidden:YES];
    //self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.title = @"Hot Pins";
    
    UIImageView* backGroundView = [[UIImageView alloc] initWithImage:bgImage];
    UIView* overlay = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 480, 480)];
    [overlay setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:.8]];
    [backGroundView addSubview:overlay];    
    self.tableView.backgroundView = backGroundView;
    //self.tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.8];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void) removeMyLocation{
    for(AddressAnnotation* annotation in pinAnnotationArray){
        if([annotation isKindOfClass:[MKUserLocation class]]){
            [pinAnnotationArray removeObject:annotation];
        }
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [pinAnnotationArray count];
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    cell.backgroundColor = [UIColor clearColor];
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"in tableview cellforrowatindex path. annotation array is %@", pinAnnotationArray);
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSInteger index = indexPath.row;
    AddressAnnotation* pinAddressAnnotation = [pinAnnotationArray objectAtIndex:index];
    
//    if([pinAddressAnnotation isKindOfClass:[MKUserLocation class]] || pastMKUserAnnotation){
//        [self setPastMKUserAnnotation:YES];
//        pinAddressAnnotation = [pinAnnotationArray objectAtIndex:index+1];
//        if(pinAddressAnnotation == nil){
//            return;
//        }
//    }
    
    // Configure the cell...
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@" E, hh:ssa"];
    NSString* user = [pinAddressAnnotation title];
    NSString* title = [NSString stringWithFormat:@"%@ - %@", user, [dateFormat stringFromDate:[pinAddressAnnotation pub_date]]];
    
    //set color of text
    [cell.textLabel setTextColor: [UIColor whiteColor]];
    [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
    
    [cell.textLabel setText:title];
    [cell.detailTextLabel setText:[pinAddressAnnotation subtitle]];
    
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    AddressAnnotation* pinToView = [pinAnnotationArray objectAtIndex:indexPath.row];
    
    //going to tableView
    tableViewController* tableView1 = [self.storyboard instantiateViewControllerWithIdentifier:@"tableViewController"];
    //[[tableView1 navigationController] setHidesBottomBarWhenPushed:NO];
    //[tableView1 setCommentArray:[[NSMutableArray alloc] initWithObjects:myNewComment, nil]];
    //[tableView1 setPin_id:[pinToView pin_id]];
    //[tableView1 setBgImage:myMapImage2];
    //[self.navigationController pushViewController:tableView1 animated:YES];
}
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    NSLog(@"in didRotatefromInterfaceOrientation");
    
    if(fromInterfaceOrientation == UIDeviceOrientationLandscapeLeft || UIDeviceOrientationLandscapeRight){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
