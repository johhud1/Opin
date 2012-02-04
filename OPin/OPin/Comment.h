//
//  Comment.h
//  mapProto
//
//  Created by John C Hudson and Bhaskar Ravi on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject <NSCoding>{
    
}

@property (strong, readwrite) NSString* mMessage;
@property (strong, readwrite) NSString* mAuthor;
@property (strong, readwrite) NSDate* mTimestamp;

-(Comment*) initWithMessage:(NSString*)message author:(NSString*)author;


@end
