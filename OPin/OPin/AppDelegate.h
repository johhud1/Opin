//
//  AppDelegate.h
//  mapProto
//
//  Created by John C Hudson and Bhaskar Ravi on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <RestKit/RestKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate> {
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, readwrite) CLLocation* curLocation;
@property (strong, readonly) CLLocationManager* locationManager;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
