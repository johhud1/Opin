//
//  tableViewController.h
//  mapProto
//
//  Created by John C Hudson and Bhaskar Ravi on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "AppDelegate.h"
#import "PinEnt.h"
#import "Pin.h"
#import "Comment.h"
#import "addCommentTableViewCell.h"
#import "viewController.h"
#import <MapKit/MapKit.h>

@interface tableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, RKRequestDelegate> {
    //IBOutlet UITableView* tableView;
}

-(id)initWithStyle:(UITableViewStyle)style Frame:(CGRect)frame ViewController:(UIViewController*)vc;
-(void) startComment;

-(void) saveComment;
-(UITextView*) getCurrentEditCommentCellEditText;
-(void) handleGetCommentsResponse:(RKResponse*)response;
-(void) handleSwipe:(UISwipeGestureRecognizer*)sender;
-(void) createGestureRecognizers;
//-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

//@property (weak, nonatomic, readwrite) UITableView* tableView;
@property (strong, nonatomic, readwrite) UIImage* bgImage;
@property (strong, nonatomic, readwrite) NSNumber* Pin_id;
@property (strong, nonatomic, readwrite) PinEnt* myPinEnt;
@property (strong, nonatomic, readwrite) Pin* thisPin;
@property (strong, nonatomic, readwrite) NSMutableArray* commentArray;
@property (strong, nonatomic, readwrite) NSManagedObjectContext* managedObjectContext;
@property (weak, nonatomic) IBOutlet UITextView *addComment_TV;
@property (weak, nonatomic, readwrite) IBOutlet UITableView* tableView;
@property (weak, nonatomic, readwrite) UIViewController* myViewController;
@property (strong, nonatomic, readwrite) UIView* swipeUpTab;
@property (strong, nonatomic, readwrite) MKAnnotationView* selectedAnn;

- (void)cancelPost;



@end
