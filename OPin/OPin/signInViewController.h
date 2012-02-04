//
//  signInViewController.h
//  mapProto
//
//  Created by John C Hudson and Bhaskar Ravi on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "viewController.h"

@interface signInViewController : UIViewController <RKRequestDelegate>
- (IBAction)signIn:(id)sender;
- (BOOL)isValidUsername:(NSString*)userName;

@property (weak, nonatomic) IBOutlet UITextField *username_tf;

@end
