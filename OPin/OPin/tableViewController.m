//
//  tableViewController.m
//  mapProto
//
//  Created by John C Hudson and Bhaskar Ravi on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "tableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "viewController.h"



@implementation tableViewController

@synthesize bgImage;
@synthesize myPinEnt;
@synthesize commentArray;
@synthesize managedObjectContext;
@synthesize addComment_TV;
@synthesize thisPin;
@synthesize Pin_id;

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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    
    //hide back button for transfer button
    self.navigationItem.hidesBackButton = TRUE;
    
    
    //ADD A CANCEL BUTTON FOR WHEN TABLE GOES INTO EDITING MODE
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                                                                          target:self action:@selector(textViewShouldEndEditing: textView)] ;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPost)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:0.7f green:0.3f blue:0.3f alpha:1]];
    //CREATE SHADOW TO ALLOW CELL TO STICK OUT
    textView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.2] ;
    textView.textColor = [UIColor whiteColor];
    textView.layer.shadowColor = [UIColor blackColor].CGColor;
    textView.layer.shadowOpacity = 0.7f;
    textView.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    textView.layer.shadowRadius = 5.0f;
    textView.layer.masksToBounds = NO;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:textView.bounds];    
    textView.layer.shadowPath = path.CGPath;

    //CREATE BORDER
    textView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveComment)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];

    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    return YES;
    
}

- (BOOL) textViewShouldEndEditing:(UITextView *)textView{
    
    //delete cancel button
    self.navigationItem.leftBarButtonItem = nil;

    textView.layer.borderWidth = 0;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(startComment)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];

    

    return YES;
}

//DISABLE RETURN ON KEYBOARD

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        return NO;
    }
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    NSInteger restrictedLength=140;
    NSString *temp=textView.text;
    if(temp.length != 0){
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    else [self.navigationItem.rightBarButtonItem setEnabled:NO];
    if([temp length] > restrictedLength){
        textView.text=[temp substringToIndex:[temp length]-1];
    } 
}

- (void) saveComment{
    //TODO: SEND COMMENT TO DATABASE
    NSString* userName = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    if(userName == nil){
        NSLog(@"error getting username in 'saveComment'");
        userName = @"NO USERNAME";
    }
    UITextView* editText = [self getCurrentEditCommentCellEditText];
    Comment* newComment = [[Comment alloc] initWithMessage:editText.text author:userName];
    NSMutableString* createCommentURL = [[NSMutableString alloc] initWithString:[constants createCommentDBURL]];
    NSString* sPin_id = [NSString stringWithFormat:@"%d", Pin_id];
    [createCommentURL appendString:sPin_id];
    NSDictionary* createCommentParams = [[NSDictionary alloc] initWithObjectsAndKeys:editText.text, @"comment", userName, @"user", nil];
    [[RKClient sharedClient] post:createCommentURL params:createCommentParams delegate:self];
    editText.text = @"";
    editText.backgroundColor = [UIColor clearColor];
    editText.layer.shadowColor = [UIColor clearColor].CGColor;
    [[self commentArray] addObject:newComment];
    [editText resignFirstResponder];
    [[self tableView] reloadData];
    
    //disable back button to wait for post to finish posting
    self.navigationItem.hidesBackButton = TRUE;
    
    UIActivityIndicatorView *activityIndicator = 
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton = 
    [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
    // Set to Left or Right
    [[self navigationItem] setLeftBarButtonItem: barButton];
    [activityIndicator startAnimating];

    
}

- (UITextView*) getCurrentEditCommentCellEditText{
    return [(addCommentTableViewCell*)[[self tableView] cellForRowAtIndexPath:(NSIndexPath*)[NSIndexPath indexPathForRow:[commentArray count] inSection:0]] editText];
    
}

- (void)cancelPost{
    UITextView* editText = [self getCurrentEditCommentCellEditText];
    editText.text = @"";
    editText.backgroundColor = [UIColor clearColor];
    editText.layer.shadowColor = [UIColor clearColor].CGColor;
    [editText resignFirstResponder];
    [[self navigationItem] setLeftBarButtonItem:nil];

    self.navigationItem.hidesBackButton = FALSE;

    NSLog(@"cancel post");
}

#pragma mark - View lifecycle
- (void)startComment {
    [self.tableView scrollToRowAtIndexPath:(NSIndexPath*)[NSIndexPath indexPathForRow:[commentArray count] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    UITextView* myEditCell = [self getCurrentEditCommentCellEditText];
    [myEditCell becomeFirstResponder];
    NSLog(@"startComment SUCCESS");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate* myDelegate = [(UIApplication*)[UIApplication sharedApplication] delegate];
    [self setManagedObjectContext:[myDelegate managedObjectContext]];

//    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 100, 32)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(startComment)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    UIImageView* backGroundView = [[UIImageView alloc] initWithImage:bgImage];
    UIView* overlay = [[UIView alloc] initWithFrame: self.navigationController.view.frame];
    [overlay setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:.8]];
    [backGroundView addSubview:overlay];    
    self.tableView.backgroundView = backGroundView;
    
    //self.navigationItem.title = thisPin.mAuthor;

    
   
}


- (void)viewDidUnload{
    [self setAddComment_TV:nil];
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"in viewWillAppear");
    [super viewWillAppear:animated];
    
    //get comments from server
    NSMutableString* getCommentURL = [[NSMutableString alloc] initWithString:[constants getCommentsFromDBURL]];
    NSString* sPin_id = [NSString stringWithFormat:@"%d", Pin_id];
    [getCommentURL appendString:sPin_id];
    NSLog(@"making request to server with url %@", getCommentURL);
    [[RKClient sharedClient] get:getCommentURL delegate:self];
    
    //set activity indicator when grabbing comments
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton = 
    [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    [[self navigationItem] setTitleView:activityIndicator];
    [activityIndicator startAnimating];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSData* myPinData = [NSKeyedArchiver archivedDataWithRootObject:[self thisPin]];
    [myPinEnt setPin:myPinData];
    NSError* error;
    [managedObjectContext save:&error];
    if(error){
        NSLog(@"ERROR SAVING COMMENT %@", [error localizedDescription]);
    }
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self commentArray] count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"in tableview cellforRowIndex Path");
    UITableViewCell* cell;
    
    if(indexPath.row == ([[self commentArray] count])){
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"addCommentCell"];
    
    }
    else{
        static NSString *CellIdentifier = @"commentCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        else{
            cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
            [cell.detailTextLabel setNumberOfLines: 0];
            cell.detailTextLabel.text = [[commentArray objectAtIndex:indexPath.row] mMessage];
            cell.textLabel.text = [[commentArray objectAtIndex:indexPath.row] mAuthor];
        }
    }
    return cell;
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"in tableViewController request, did load response. request was %@, and response was %@", request.HTTPBodyString, response.bodyAsString);
    NSMutableString* createCommentURL = [[NSMutableString alloc] initWithString:[constants createCommentDBURL]];
    NSString* sPin_id = [NSString stringWithFormat:@"%d", Pin_id];
    [createCommentURL appendString:sPin_id];
    NSMutableString* getCommentsUrl = [[NSMutableString alloc] initWithString:[constants getCommentsFromDBURL]];
    [getCommentsUrl appendString:sPin_id];
    if([request wasSentToResourcePath:createCommentURL]){
        NSLog(@"got createCommentURL response successfully");
    }
    else{
        NSLog(@"got getCommentResponse request, handling");
        [self handleGetCommentsResponse:response];
    }
    
    //RECREATE BACK BUTTON COMMENT HAS BEEN POSTED
    [[self navigationItem] setLeftBarButtonItem:nil];
    //[activityIndicator stopAnimating];
    self.navigationItem.hidesBackButton = FALSE;

}
- (void) handleGetCommentsResponse:(RKResponse*) response{
    NSLog(@"in handleGetCommentsResponse");
    NSError* jsonError;
    NSArray* responseJSONArray = [NSJSONSerialization JSONObjectWithData:[response body] options:NSJSONReadingAllowFragments error:&jsonError];
    NSLog([jsonError localizedDescription]);
    NSMutableArray* responseCommentArray = [[NSMutableArray alloc] init]; 
    NSDictionary* commentModelDict;
    for(commentModelDict in responseJSONArray){
        NSDictionary* commentsFields = [commentModelDict valueForKey:[constants getJSONFieldsKey]];
        NSString* comment = [commentsFields valueForKey:[constants getJSONCommentKey]];
        NSString* author = [commentsFields valueForKey:[constants getJSONAuthorKey]];
        Comment* tempComment = [[Comment alloc] initWithMessage:comment author:author];
        NSLog(@"adding comment %@", tempComment);
        [responseCommentArray addObject:tempComment];
    }
    [self setCommentArray:responseCommentArray];
    [[self tableView] reloadData];
    
    [[self navigationItem] setTitleView:nil];
    //re-enable back button signaling comment is stored in db
    //[[[self navigationItem] leftBarButtonItem] setEnabled:TRUE];
    

}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor clearColor];
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
}

@end
