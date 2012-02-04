//
//  Pin.h
//  mapProto
//
//  Created by John C Hudson and Bhaskar Ravi on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Comment.h"

@interface Pin : NSObject <NSCoding>{
    
}
- (void) encodeWithCoder:(NSCoder *)aCoder;
- (id) initWithCoder:(NSCoder *)aDecoder;

@property (readwrite, strong) NSString* mAuthor;
@property (readwrite, strong) NSMutableArray* mCommentArray;

@end
