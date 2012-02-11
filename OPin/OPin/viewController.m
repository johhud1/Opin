//
//  navController.m
//  mapProto
//
//  Created by John C Hudson and Bhaskar Ravi on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "topicList.h"
#import "viewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AddressAnnotation.h"

@implementation viewController {
}

@synthesize mUsername;
@synthesize myToolbar;
@synthesize myNewComment;
@synthesize myLocManager;
@synthesize myMap;
@synthesize slideInTF;
@synthesize managedObjectContext;
@synthesize animateView;
@synthesize upperRightToolBut;
@synthesize textViewVisible;
@synthesize myCurrentAnn;
@synthesize myCurrentPinEnt;
@synthesize isRemovePinBarItemSet;
@synthesize mTableViewController;
@synthesize isTableFullScreen;

-(void)viewDidLoad{
    
    //we must REASIGN THE CURRENT ANNOTATION IN THE VIEW DID LOAD :D
    //[self setMyCurrentAnn: myCurrentAnn];

    myLocManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] locationManager];
    textViewVisible = NO;
    NSLog([[NSUserDefaults standardUserDefaults] stringForKey:@"username"]);
    mUsername = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    //[[self navigationController] setToolbarHidden:YES];
    //NSTimer* refreshPinsTimer = 
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(getPinsFromDB) userInfo:nil repeats:YES];
    
    self.navigationItem.title = @"Opin";
    isRemovePinBarItemSet = FALSE;
    isTableFullScreen = FALSE;
    //[self.navigationController setToolbarHidden:NO animated:YES];
    UIBarButtonItem *flexibaleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.navigationItem.hidesBackButton = TRUE;
    
        
    UIBarButtonItem *areaListButton = [[UIBarButtonItem alloc] initWithTitle:@"List" 
                                                                       style:UIBarButtonItemStyleBordered 
                                                                      target:self 
                                                                      action: @selector(pushToAreaListView:)];
                                       
    self.toolbarItems = [NSArray arrayWithObjects:flexibaleSpaceBarButton, areaListButton, nil];
    
    //[areaListBut addTarget:self action: @selector(pushToAreaListView::) forControlEvents:UIControlEventTouchUpInside];
    
    [self jumpToMyLoc];
    
    NSLog(@"about to instantiate tableviewcontroller");
    mTableViewController = [[tableViewController alloc] 
                            initWithStyle:UITableViewStylePlain Frame:CGRectMake(0, 0, 320, CGRectGetHeight([[self view] frame])) ViewController:self];
    //[[tableViewController navigationController] setHidesBottomBarWhenPushed:NO];
    [(tableViewController*)mTableViewController setCommentArray:[[NSMutableArray alloc] initWithObjects:myNewComment, nil]];
    UITableView* tableView = (UITableView*)[mTableViewController view];
    [tableView setHidden:YES];
    NSLog(@"added tableview as a subview");
    [[self view] addSubview:tableView];
    [[self view] sendSubviewToBack:tableView];
    [self createGestureRecognizers];

}

-(void)viewDidAppear:(BOOL)animated{
    [self getPinsFromDB];

}

-(void) createGestureRecognizers{
    UISwipeGestureRecognizer* tableSwipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [tableSwipeDownGestureRecognizer setNumberOfTouchesRequired:1];
    UISwipeGestureRecognizer* tableSwipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [tableSwipeDownGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [tableSwipeUpGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [[self view] addGestureRecognizer:tableSwipeUpGestureRecognizer];
    [[self view] addGestureRecognizer:tableSwipeDownGestureRecognizer];
    //[[[myMap gestureRecognizers] objectAtIndex:0] requireGestureRecognizerToFail:tableSwipeGestureRecognizer];
}


-(void) handleSwipe:(UISwipeGestureRecognizer*)sender{
    if([sender direction] == UISwipeGestureRecognizerDirectionDown){
        NSLog(@"handling swipe down");
        [self slideMapTo:CGRectGetHeight([[self view] frame])];
    }
//    else if([sender direction] == UISwipeGestureRecognizerDirectionUp){
//        NSLog(@"handling swipe up");
//        [self slideMapTo:0];
//    }
}

//DISABLE RETURN KEY FOR KEYBOARD OF ANIMATED TEXTFIELD
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}

- (void) getPinsFromDB{
    [[RKClient sharedClient] get:[constants getPinsFromDBURL] delegate:self];
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *aV; 
    for (aV in views) {
        if ([aV.annotation isKindOfClass:[MKUserLocation class]]) {
            myUserLocation = aV;
        }
    }
}

- (void)mapView:(MKMapView *)mv didUpdateUserLocation:(MKUserLocation *)userLocation{

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [self setMyMap:nil];
    [self setAnimateView:nil];
    [self setSlideInTF:nil];
    [self setUpperRightToolBut:nil];
    [self setMyToolbar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //return YES;

    //return YES;
}

- (IBAction)newEvent:(id)sender {
    if(textViewVisible){
        [self removeExistingPins];
        [self addUserAnnotation:[myLocManager location]];
        [self slideInTV];
    }
    else{
        [self slideOutTV];
    }
}

- (void)slideOutTV{
   // [self slideMapTo:80];
    [self jumpToMyLoc];
    

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self action:@selector(cancelPost)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:0.7f green:0.3f blue:0.3f alpha:1]];

    upperRightToolBut.title = @"Done";

    [UIView animateWithDuration:.7 animations:
     ^{
         
         [[self view] bringSubviewToFront:animateView];
         [self slideMapBottomUp:100];
                  //animateView.frame = CGRectMake(0, 0, 320, 69);
         
         //BASE SHADOW LAYER FOR ANIMATEVIEW
         animateView.frame = CGRectMake(0, 0, 320, 85);
         UIImage *backgroundImage = [UIImage imageNamed:@"tableTileBlack.png"];
         UIColor *backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];
         animateView.backgroundColor = backgroundColor;
         animateView.textColor = [UIColor whiteColor];

//         animateView.layer.shadowColor = [UIColor blackColor].CGColor;
//         animateView.layer.shadowOpacity = 0.8f;
//         animateView.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
//         animateView.layer.shadowRadius = 5.0f;
//         animateView.layer.masksToBounds = NO;
                 
         //TRAPIZOIDAL EFFECT
//         CGSize size = animateView.bounds.size;
//         UIBezierPath *path = [UIBezierPath bezierPath];
//         [path moveToPoint:CGPointMake(size.width * 0.08f, size.height * 0.90f)];
//         [path addLineToPoint:CGPointMake(size.width * 0.86f, size.height * 0.90f)];
//         [path addLineToPoint:CGPointMake(size.width * 1.15f, size.height * 1.15f)];
//         [path addLineToPoint:CGPointMake(size.width * -0.15f, size.height * 1.15f)];
         
         [animateView becomeFirstResponder];
         animateView.layer.borderColor = [[UIColor grayColor] CGColor];  
         [upperRightToolBut setEnabled:NO];
        }
                     completion:^(BOOL finished){
                         textViewVisible = YES;
                         NSLog(@"done slide out");
                     }];
}

- (void)slideInTV{

    [animateView resignFirstResponder];
    [UIView animateWithDuration:.3 animations:
     ^{
         //self.navigationItem.leftBarButtonItem = nil;
         animateView.frame = CGRectMake(0, -80, 320, 69);
         myMap.frame = CGRectMake(0,0,320, 415);
         [upperRightToolBut setTitle:@"What's up?"];
     }
                     completion:^(BOOL finished){
                         animateView.text = @"";
                         textViewVisible = NO;
                         NSLog(@"done slide in");
                         animateView.layer.shadowColor = [UIColor clearColor].CGColor;

                     }];
}
    
- (void)cancelPost{
    upperRightToolBut.title = @"What's up?";
    [self slideInTV];
    [[[self navigationItem] rightBarButtonItem] setEnabled:TRUE];
    if(isRemovePinBarItemSet){
        [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:
                                                    @selector(removeExistingPins)]];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0.7f green:0.3f blue:0.3f alpha:1];
    }
    else{
        [[self navigationItem] setLeftBarButtonItem:nil];
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    
    NSInteger restrictedLength=140;
    
    NSString *temp=textView.text;
    if(temp.length != 0){
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    else [self.navigationItem.rightBarButtonItem setEnabled:NO];
    if([[textView text] length] > restrictedLength){
        textView.text=[temp substringToIndex:[temp length]-1];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if([[view.annotation title] isEqualToString:[myCurrentAnn title]]){
        isRemovePinBarItemSet = TRUE;
        if(!textViewVisible){
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:
                                                 @selector(removeExistingPins)];
            self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0.7f green:0.3f blue:0.3f alpha:1];
        }
    }
    else{
        isRemovePinBarItemSet = FALSE;
    }
    if(![[view annotation] isKindOfClass:[MKUserLocation class]]){
        [NSObject cancelPreviousPerformRequestsWithTarget:self]; 
        [view setImage:[UIImage imageNamed:@"opinPinSelectedTest.png"]];
        [(tableViewController*)mTableViewController setSelectedAnn:[view annotation]];
        //int mPin_id = [[(AddressAnnotation*)[view annotation] pin_id] intValue];
        [(tableViewController*)mTableViewController setPin_id:[(AddressAnnotation*)[view annotation] pin_id]];
        NSLog(@"making tableview with pin_id %@", [(tableViewController*)mTableViewController Pin_id]);
        [[mTableViewController tableView] setHidden:NO];
        //[[self view] bringSubviewToFront:[mTableViewController tableView]];
        [mTableViewController viewWillAppear:NO];
        [[mTableViewController tableView] setScrollEnabled:NO];
        [self slideMapTo:80];
    }
}

-(void) slideMapTo:(int)pixels{
    [UIView animateWithDuration:.4 animations:
     ^{
         int height = CGRectGetHeight([[[self navigationController] view] frame]);
        [[self myMap] setFrame:CGRectMake(0, pixels, 320, height)];
        }
    completion:^(BOOL finished){
        NSLog(@"done sliding map down");
    }];
}

-(void) slideMapBottomUp:(int)pixels{
    [UIView animateWithDuration:.4 animations:^{
        CGRect mapRect = [myMap frame]; 
        CGRect newMapRect = CGRectMake(CGRectGetMinX(mapRect), CGRectGetMinY(mapRect), CGRectGetWidth(mapRect), CGRectGetHeight(mapRect)-pixels);
        [[self myMap] setFrame:newMapRect];
    }
    completion:^(BOOL finished){
        NSLog(@"done sliding map bottom up");
    }
     ];
}

//-(void) slideMapUpTo:(int)pixels{
//    [UIView animateWithDuration:.4 animations:^{
//
//            [[self myMap] setFrame:CGRectMake(0, 0, 320, 415)];
//        }
//    completion:^(BOOL finished){
//        NSLog(@"slide in map");
//    }];
//    //[[mTableViewController tableView] setHidden:YES];
//
//}


- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    if(!textViewVisible){
        self.navigationItem.leftBarButtonItem = nil;
        isRemovePinBarItemSet = FALSE;
    }

    //[[mTableViewController tableView] setHidden:YES];
    if([[view annotation] isKindOfClass:[AddressAnnotation class]]){
        [self performSelector:@selector(slideMapTo:) withObject:0 afterDelay:0.1];
        [view setImage:[UIImage imageNamed:@"opinPinSMALL.png"]];
    }
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myPin"];
    //[annView release];
    //annView.canShowCallout = YES;
    if([(AddressAnnotation*) annotation isMyPin]){
        annView.image = [UIImage imageNamed:[NSString stringWithFormat:@"opinPinSMALL.png"]];
    }
    else{
//        annView.pinColor = MKPinAnnotationColorGreen;
        annView.image = [UIImage imageNamed:[NSString stringWithFormat:@"opinPinSMALL.png"]];

//  
    }

    //setup callout detail button
    UIButton* calloutDetailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    int buttonTag = [[(AddressAnnotation*)annotation pin_id] intValue];
    NSLog(@"in mapView:viewForAnnotation; annotation.pin_id is %d, and myCurrentAnn.pin_id is %@", buttonTag, [myCurrentAnn pin_id]);
    [calloutDetailButton setTag:buttonTag];
    [annView setTag:buttonTag];
    [calloutDetailButton addTarget:self action:@selector(pushToDetailView:) forControlEvents:UIControlEventTouchUpInside];
    
    //set calloutDetailView button to right detail view of callout
    [annView setRightCalloutAccessoryView:calloutDetailButton];
    
    //setup callout like button
    UIButton* likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeButton setTag:buttonTag];
    [likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [likeButton setAdjustsImageWhenDisabled:NO];
    //get 'button can be pressed' image
    UIImage* canLikeImage = [UIImage imageNamed:[constants handCanLike]];
    CGSize canLikeSize = [canLikeImage size];
    UIImage* alreadyLikedImage = [UIImage imageNamed:[constants handAlreadyLiked]];
    
    [likeButton setFrame:CGRectMake(0, 0, canLikeSize.width, canLikeSize.height)];
    [likeButton setImage:canLikeImage forState:UIControlStateNormal];
    [likeButton setImage:alreadyLikedImage forState:UIControlStateDisabled];
    //set calloutLikeButton to left detail view of callout
    [annView setLeftCalloutAccessoryView:likeButton];
    
    return annView;
}
//- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
//    NSLog(@"in calloutAccessoryControlTapped");
//    [control setTag:[view tag]];
//    NSLog(@"MKAnnotationView tag is %d, and UIControl (callout detail button) tag is %d", [view tag], [control tag]);
//}
-(void)likeButtonPressed:(id)likeButton{
    NSNumber* mTag = [[NSNumber alloc] initWithInt:[likeButton tag]];

    NSString* sPin_id = [[NSString alloc] initWithFormat:@"%@", mTag];
    NSLog(@"like button has been pushed, disabling, tag is %d", [likeButton tag]);

    [likeButton setEnabled:NO];
    //send 'like' off to server.
    
    NSString* likeFinalURL = [[NSString alloc] initWithFormat:@"%@/%@/%@", [constants likeURL], sPin_id, mUsername];
    NSLog(@"making like request to url %@", likeFinalURL);
    [[RKClient sharedClient] requestWithResourcePath:likeFinalURL delegate:self];
}

-(void)pushToDetailView:(UIButton*)sender{
    NSLog(@"push to detail View SUCCESS, tag is %d", [sender tag]);
    //Take Screenshot of map and convert to image
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(myMap.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(myMap.frame.size);
    }
    UIImage* myMapImage2 = [UIImage alloc];
    [myMap.layer renderInContext:UIGraphicsGetCurrentContext()];
    myMapImage2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContext(myMap.frame.size);
    [myMap.layer renderInContext:UIGraphicsGetCurrentContext()];
    myMapImage2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); 
    
    //going to tableView
    //tableViewController* mTableViewController = [[tableViewController alloc] init];
    //[self.storyboard instantiateViewControllerWithIdentifier:@"tableViewController"];
    //[[tableViewController navigationController] setHidesBottomBarWhenPushed:NO];
//    [tableViewController setCommentArray:[[NSMutableArray alloc] initWithObjects:myNewComment, nil]];
//    NSNumber* mTag = [[NSNumber alloc] initWithInt:[sender tag]];
//    [tableViewController setPin_id:mTag];
//    [tableViewController setBgImage:myMapImage2];
//    [self.navigationController pushViewController:tableViewController animated:YES];    
}

    //remove previous post
- (void)removeExistingPins{
    //NSString* myIdNSString = [[NSUserDefaults standardUserDefaults] objectForKey:@"PinEnt"];
//    if(myIdNSString != nil){
//    }
    if([self myCurrentAnn] != nil){
        NSMutableString* deleteCommentURL = [[NSMutableString alloc] initWithString:[constants deletePinFromDBURL]];
        NSString* sPin_id = [[NSString alloc] initWithFormat:@"%@", [myCurrentAnn pin_id]];
        [deleteCommentURL appendString:sPin_id];
        [[RKClient sharedClient] get:deleteCommentURL delegate:self];
        [myMap removeAnnotation:[self myCurrentAnn]];
        NSLog(@"just removed myCurrentAnn %@ from map", myCurrentAnn.pin_id);
        [self setMyCurrentAnn:nil];
    }  
}

//called when a user click's the whatsup, button a second time. aka the save button
- (void)addUserAnnotation:(CLLocation*)myloc{
    NSString* username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    if(username == nil){
        username = @"COULDN'T RETRIEVE USERNAME :(";
    }
    NSNumber* doubleLat = [[NSNumber alloc] initWithDouble:[myloc coordinate].latitude];
    NSNumber* doubleLong = [[NSNumber alloc] initWithDouble:[myloc coordinate].longitude];
    AddressAnnotation *annotation = [[AddressAnnotation alloc] initWithCoordinate:[myloc coordinate]];
    annotation.title = username;
    annotation.subtitle = animateView.text;
    annotation.isMyPin = TRUE;
    myNewComment = [[Comment alloc] initWithMessage:animateView.text author:username];
    Pin* myPin = [[Pin alloc] init];
    [myPin setMAuthor:username];
    
    //MKPinAnnotationView.annotation.pinColor = MKPinAnnotationColorPurple;
    
    NSData* myData = [NSKeyedArchiver archivedDataWithRootObject:myPin];
    
    PinEnt* pinEnt = [NSEntityDescription insertNewObjectForEntityForName:@"PinEnt"
                                              inManagedObjectContext:[self managedObjectContext]];
    float floatLat =  (float)[doubleLat floatValue];
    float floatLong = (float)[doubleLong floatValue];
    pinEnt.lat = doubleLat;
    pinEnt.lng = doubleLong;
    pinEnt.message = annotation.subtitle;
    pinEnt.timestamp = [NSDate date];
    pinEnt.pin = myData;
    NSError* error;
    if (![managedObjectContext save:&error]){
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    [[NSUserDefaults standardUserDefaults] setObject:[[[pinEnt objectID] URIRepresentation] absoluteString] forKey:@"PinEnt"];
    NSMutableString* createPinPath = [[NSMutableString alloc] initWithString:@"/createPin/"];
    [createPinPath appendString:username];
    
    NSDictionary* createPinParams = [[NSDictionary alloc] initWithObjectsAndKeys:myNewComment.mMessage, @"comment", [[NSNumber alloc] initWithFloat:floatLat], @"latitude", [[NSNumber alloc] initWithFloat:floatLong], @"longitude", nil];

    NSLog(@"this is the params sent to createPin url %@",[createPinParams stringWithURLEncodedEntries]);

    [[RKClient sharedClient] post:createPinPath params:createPinParams delegate:self];
    //adding the pin is handled in didLoadResponse, since we can't add the pin till we get the pin_id in the server's response
    
    // set what's up to false to incorporate server response time
    [[[self navigationItem] rightBarButtonItem] setEnabled:FALSE];
    //self.navigationItem.leftBarButtonItem = nil;
    
    //creates busy indicator showing that pin is going to be post
    UIActivityIndicatorView *activityIndicator = 
                    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
    // Set to Left
    [[self navigationItem] setLeftBarButtonItem: barButton];
    [activityIndicator startAnimating];
    [self setMyCurrentAnn:annotation];
    [self jumpToMyLoc];
    
    

}

- (void) jumpToMyLoc{
    MKMapView* myMapView = self.myMap;
    CLLocation* mp = [myLocManager location];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate] ,5*METERS_PER_MILE,5*METERS_PER_MILE);
    [myMapView setRegion:region animated:YES];
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"in request did load response. request was %@, and response is written to file", request.HTTPBodyString);
    NSError* error;
    [ response.bodyAsString writeToFile:@"/Users/jack/Documents/Opin/file.html" atomically:YES encoding:NSUnicodeStringEncoding error:&error ];
    
    if([request wasSentToResourcePath:[constants getPinsFromDBURL]]){
        
        //[self performSelectorInBackground:@selector(handlePinQueryResponse:) withObject:response];
        // detachnewthread to handle pinQuery stuff in the background
        [self handlePinQueryResponse:response];
    }
    else if([[response bodyAsString] isEqualToString:[constants deletePinSuccessResponse]]){
        NSLog(@"pin deleted from DB successfully");
    }
    else if([[response bodyAsString] isEqualToString:[constants likePinSuccessResponse]]){
        NSLog(@"pin liked at DB successfully");
    }
    else{
        [self handleCreatePinResponse:response];
    }
}

-(void) handleCreatePinResponse:(RKResponse *)response{
    NSLog(@"in handleCreatePinResponse, response should be the pin_id, response is: %@", [response bodyAsString]);

    NSString* sPin_id = [response bodyAsString];
    NSNumber* pin_id = [[NSNumber alloc] initWithInt:[sPin_id intValue]];
    NSLog(@"setting myCurrentAnn pin_id as %@", pin_id);
    
    //COULD TRY AND ADD AN EXTRA DELETION RIGHT HERE
    
    [myCurrentAnn setPin_id:pin_id];
    [myCurrentAnn setPub_date:[NSDate date]];
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    // Convert date object to desired output format
//    [dateFormat setDateFormat:@" E, hh:ssa"];
//    NSString* dateStr = [dateFormat stringFromDate:[NSDate date]];
//
//    NSString* finalTitle = [NSString stringWithFormat:@"%@ - %@", [myCurrentAnn title], dateStr];
//    [myCurrentAnn setTitle:finalTitle];
    [self.myMap addAnnotation:myCurrentAnn];
    
    //Once pin is created, allow user to create a new pin once more
    [[[self navigationItem] rightBarButtonItem] setEnabled:TRUE];
    
    //disable activity indicator
    
    self.navigationItem.leftBarButtonItem = nil;

}

- (void) handlePinQueryResponse:(RKResponse*)response{
    NSLog(@"in handlePinQueryResponse");
    NSError* jsonError;
    NSArray* responseJSONArray = [NSJSONSerialization JSONObjectWithData:[response body] options:NSJSONReadingAllowFragments error:&jsonError];
    
    //create dictionary from current map annotation and their id's
    NSArray* annotationArray = [myMap annotations];
    NSMutableArray* annotationIDsArray = [self getAnnotationIDs:annotationArray];
    //NSLog(@"just created array of id's from annotationArray, array of id's is %@", annotationIDsArray);
    NSMutableDictionary* annotationDic = [[NSMutableDictionary alloc] initWithObjects:annotationArray forKeys:annotationIDsArray];
    [annotationDic removeObjectForKey:@"myLoc"];
    //NSLog(@"just attempted to remove myLoc annotation from annotationDic, annotationDic is: %@", annotationDic);
    
    //set all current annotations valid flag to false
    [self invalidateAnnotationPins:[annotationDic allValues]];
    NSLog([jsonError localizedDescription]);
    NSDictionary* pinModelDict;
    for(pinModelDict in responseJSONArray){
        NSDictionary* pinFields = [pinModelDict valueForKey:[constants getJSONFieldsKey]];
        NSString* user = [pinFields valueForKey:@"user"];
        NSString* firstComment = [pinFields valueForKey:@"firstComment"];
        Pin* newPin = [[Pin alloc] init];
        [newPin setMAuthor:[pinFields valueForKey:@"user"]];
        [newPin setMCommentArray:[[NSMutableArray alloc] initWithObjects:[[Comment alloc] initWithMessage:firstComment author:user], nil]];
        NSNumber* lat = [pinFields valueForKey:@"lat"];
        NSNumber* lng = [pinFields valueForKey:@"long"];
        NSNumber* dbpin_id = [pinModelDict valueForKey:@"pk"];
        CLLocation* myloc = [[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[lng doubleValue]];

        //NSLog(@"iterating through JSONresponse, checking for annotation with ID %@", dbpin_id);
        AddressAnnotation* annotation = [[AddressAnnotation alloc] initWithCoordinate:[myloc coordinate]];
        [self setAnnotation:annotation withDateString:[pinFields valueForKey:@"pub_date"]];
        // Convert date object to desired output format                                         //TIMESTAMP/DATE FOR PINS HERE
//        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
//        [dateFormat setDateFormat:@" E, hh:ssa"];
//        NSString* title = [NSString stringWithFormat:@"%@ - %@", user, [dateFormat stringFromDate:[annotation pub_date]]];
        [annotation setTitle:user];
        [annotation setSubtitle:firstComment];
        [annotation setPin_id:dbpin_id];
        
        //check to see if you have a pin already on the map
        NSString* username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
        if ([user isEqualToString:username]) {
            [self setMyCurrentAnn:annotation];
            [annotation setIsMyPin:TRUE];
        }
        else{
            [annotation setIsMyPin:FALSE];
        }

        AddressAnnotation* tempAnnotation;
        if((tempAnnotation = [annotationDic objectForKey:dbpin_id])){
            [tempAnnotation setIsValid:TRUE];
        }
        else{
            [annotation setIsValid:TRUE];
            [myMap addAnnotation:annotation];
        }
    }
    [self removeInvalidAnnotations:[annotationDic allValues]];
}


-(void) removeInvalidAnnotations:(NSArray*)annotations{
    AddressAnnotation* annotation;
    for (annotation in [myMap annotations]) {
        if([annotation isKindOfClass:[AddressAnnotation class]]){
            if(([annotation isValid] == FALSE)){
                [myMap removeAnnotation:annotation];
            }
        }
    }
}





-(NSMutableArray*) getAnnotationIDs:(NSArray *)annotations{
    AddressAnnotation* annotation;
    NSMutableArray* annotationIDs = [[NSMutableArray alloc] init];
    for (annotation in annotations) {
        if(![annotation isKindOfClass:[MKUserLocation class]]){
            [annotationIDs addObject:[annotation pin_id]];
        }
        else{
            [annotationIDs addObject:@"myLoc"];
        }
    }
    return annotationIDs;
}

- (void) invalidateAnnotationPins:(NSArray *)annotationPins{
    AddressAnnotation* pinAnnotation;
    for (pinAnnotation in annotationPins) {
        [pinAnnotation setIsValid:FALSE];
    }
}

- (void) setAnnotation:(AddressAnnotation *)annotation withDateString:(NSString *)dateStr{
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:dateStr];  
    
    NSLog(@"setting annotation pub_date to %@", date);
    [annotation setPub_date:date];
}


- (void)pushToAreaListView:(id)sender{
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(myMap.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(myMap.frame.size);
    }
    UIImage* myMapImage2 = [UIImage alloc];
    [myMap.layer renderInContext:UIGraphicsGetCurrentContext()];
    myMapImage2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();   
    UIGraphicsBeginImageContext(myMap.frame.size);
    [myMap.layer renderInContext:UIGraphicsGetCurrentContext()];
    myMapImage2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); 
    
    topicList* topicList = [self.storyboard instantiateViewControllerWithIdentifier:@"topicList"];
    [topicList setPinAnnotationArray:[myMap annotations]];
    //
    [topicList setBgImage:myMapImage2];
    [self.navigationController pushViewController:topicList animated:YES];
    
}



@end

