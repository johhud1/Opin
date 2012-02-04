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

#define METERS_PER_MILE 1609.344

@interface AddressAnnotation : NSObject<MKAnnotation> {
}

@property (readwrite, nonatomic) BOOL isMyPin;
@property (readwrite, strong, nonatomic) NSDate* pub_date;
@property (readwrite, nonatomic) BOOL isValid;
@property (readwrite, retain, nonatomic) NSNumber* pin_id;
@property (readwrite, nonatomic) CLLocationCoordinate2D coordinate;
@property (readwrite, copy, nonatomic) NSString* title;
@property (readwrite, copy, nonatomic) NSString* subtitle;
-(id)initWithCoordinate:(CLLocationCoordinate2D) c;

@end

@interface viewController : UIViewController <MKMapViewDelegate, UITextViewDelegate, RKRequestDelegate>{
    MKUserLocation* myUserLocation;
    NSTimer* refreshPinsTimer;
}

- (void)setAnnotation:(AddressAnnotation*)annotation withDateString:(NSString*)dateStr;
- (void)pushToDetailView:(id)sender;
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


extern UIImage* myMapImage2;
 

@property (weak, nonatomic) IBOutlet UIToolbar *myToolbar;

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
@end
