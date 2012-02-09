//
//  topicList.h
//  OPin
//
//  Created by John C Hudson on 2/7/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "Pin.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface topicList : UITableViewController

@property (readwrite, nonatomic, strong) NSMutableArray* pinAnnotationArray;
@property (readwrite, nonatomic) BOOL pastMKUserAnnotation;
@property (strong, nonatomic, readwrite) UIImage* bgImage;

-(void) removeMyLocation;

@end
