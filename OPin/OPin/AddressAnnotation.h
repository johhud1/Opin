//
//  AddressAnnotation.h
//  OPin
//
//  Created by John C Hudson on 2/7/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

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
