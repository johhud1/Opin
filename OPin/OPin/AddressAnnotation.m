//
//  AddressAnnotation.m
//  OPin
//
//  Created by John C Hudson on 2/7/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "AddressAnnotation.h"

@implementation AddressAnnotation

@synthesize isMyPin;
@synthesize pub_date;
@synthesize isValid;
@synthesize pin_id;
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
    isValid = TRUE;
    coordinate = c;
    NSLog(@"%f,%f", c.latitude, c.longitude);
    return self;
}
@end