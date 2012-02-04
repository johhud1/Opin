//
//  PinEnt.h
//  mapProto
//
//  Created by John C Hudson and Bhaskar Ravi on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PinEnt : NSManagedObject{
}
//- (BOOL)isEqual:(PinEnt*)anObject;

@property (nonatomic, retain, readwrite) NSNumber * lat;
@property (nonatomic, retain, readwrite) NSNumber * lng;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain, readwrite) NSNumber* pin_id;
@property (nonatomic, retain) id pin;
@property (nonatomic, readwrite) BOOL valid;

@end
