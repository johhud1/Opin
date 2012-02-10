//
//  navController.h
//  mapProto
//
//  Created by John C Hudson and Bhaskar Ravi on 12/19/11.
//  Copyright (c) 2011 OPin. All rights reserved.
//
#import "AppDelegate.h"
#import "tableViewController.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreData/NSManagedObject.h>
#import "Comment.h"
#import <MapKit/MapKit.h>
#import "Pin.h"
#import "PinEnt.h"
#import <RestKit/RestKit.h>
#import "constants.h"
#import "AddressAnnotation.h"

#define METERS_PER_MILE 1609.344



@interface viewController : UIViewController <MKMapViewDelegate, UITextViewDelegate, RKRequestDelegate>{
    MKUserLocation* myUserLocation;
    NSTimer* refreshPinsTimer;
    
}

- (void)setAnnotation:(AddressAnnotation*)annotation withDateString:(NSString*)dateStr;
- (void)pushToDetailView:(id)sender;
- (void)likeButtonPressed:(id)likeButton;
- (void)slideInTV;
- (void)slideOutTV;
- (void)cancelPost;
- (void)jumpToMyLoc;
- (void)removeExistingPins;
- (void)addUserAnnotation:(CLLocation*)myloc;
- (IBAction)newEvent:(id)sender;
- (void) getPinsFromDB;
//- (void) initThreadGetPinsFromDB;
- (void) handlePinQueryResponse:(RKResponse*)response;
- (void) handleCreatePinResponse:(RKResponse*)response;
- (void) invalidateAnnotationPins:(NSArray*)CoreDataPins;
- (NSMutableArray*) getAnnotationIDs:(NSArray*)annotations;
- (void) removeInvalidAnnotations:(NSArray*)annotations;
- (void)pushToAreaListView:(id)sender;
-(void) slideMapDown:(int)pixels;


extern UIImage* myMapImage2;
 

@property (weak, nonatomic) IBOutlet UIToolbar *myToolbar;

@property (strong, readwrite, nonatomic) NSString* mUsername;
@property (strong, readwrite) Comment* myNewComment;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *upperRightToolBut;
@property (readwrite) BOOL textViewVisible;
@property (weak, nonatomic) IBOutlet MKMapView *myMap;
@property (weak, nonatomic) IBOutlet UITextField *slideInTF;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) IBOutlet UITextView *animateView;
@property (strong, nonatomic) CLLocationManager* myLocManager;
@property (strong, nonatomic, readwrite) PinEnt* myCurrentPinEnt;
@property (strong, nonatomic, readwrite) AddressAnnotation* myCurrentAnn;
@property (nonatomic, readwrite) BOOL isRemovePinBarItemSet;
@property (nonatomic, strong, readwrite) tableViewController* mTableViewController;
@end
