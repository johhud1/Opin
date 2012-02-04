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

@interface tableViewController : UITableViewController <UITextViewDelegate, RKRequestDelegate> {

}
-(void) startComment;

-(void) saveComment;
-(UITextView*) getCurrentEditCommentCellEditText;
-(void) handleGetCommentsResponse:(RKResponse*)response;

@property (strong, nonatomic, readwrite) UIImage* bgImage;
@property (nonatomic, readwrite) int Pin_id;
@property (strong, nonatomic, readwrite) PinEnt* myPinEnt;
@property (strong, nonatomic, readwrite) Pin* thisPin;
@property (strong, nonatomic, readwrite) NSMutableArray* commentArray;
@property (strong, nonatomic, readwrite) NSManagedObjectContext* managedObjectContext;
@property (weak, nonatomic) IBOutlet UITextView *addComment_TV;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;


- (void)cancelPost;



@end
