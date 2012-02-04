//
//  signInViewController.m
//  mapProto
//
//  Created by John C Hudson and Bhaskar Ravi on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "signInViewController.h"

@implementation signInViewController
@synthesize username_tf;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/
-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"Sign In";
    
    UIImage *backgroundImage = [UIImage imageNamed:@"OPinBackground.png"];
    UIColor *backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];
    //self.backgroundColor = backgroundColor;
    self.navigationController.view.backgroundColor = backgroundColor;    
    //[backGroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    
//    UIView* overlay = [[UIView alloc] initWithFrame: self.view.frame];
//    [overlay setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:.8]];
//    [signInViewController.view addSubview:overlay];
    
    //self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];

    //[viewController setbackgroundcolor] = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    
//    self.view.backgroundColor = blackColor;
//    editText.backgroundColor = [UIColor clearColor];
    
    
    
    //[self backg

    
}

- (void)viewDidUnload
{
    [self setUsername_tf:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL) isValidUsername:(NSString *)userName{
    NSString *usernameRegex = @"[A-Z0-9a-z]{1,20}"; 
    NSPredicate *usernameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", usernameRegex]; 
    
    return [usernameTest evaluateWithObject:userName];
}
- (IBAction)signIn:(id)sender {
    if(![self isValidUsername:[username_tf text]]){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Rejected!"
                                                          message:@"Username's cannot have spaces or other special characters, and must be between 1 and 20 characters. Try again."
                                                         delegate:nil
                                                cancelButtonTitle:@"FINE"
                                                otherButtonTitles:nil];
        
        [message show];
    }
    else{
        NSMutableString* createUserPath = [[NSMutableString alloc] initWithString:@"/createUser/"];
        [createUserPath appendString:[self username_tf].text];
        [[RKClient sharedClient] get:createUserPath delegate:self];
    }
    //RKReachabilityObserver myRO = [[RKReachabilityObserver alloc] initWithHost:@"/localhost"];
//    
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"in request in sign in delegate, did load response. request was %@, and response was %d", request.URL, response.statusCode);
    if([response isForbidden]){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Rejected!"
                                                          message:@"That username is already taken. Please choose another"
                                                         delegate:nil
                                                cancelButtonTitle:@"FINE"
                                                otherButtonTitles:nil];
        
        [message show];
        
    }
    else{
        [[NSUserDefaults standardUserDefaults] setObject:[self username_tf].text forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popViewControllerAnimated:YES];

    }
}
@end
