//
//  Pin.m
//  mapProto
//
//  Created by John C Hudson and Bhaskar Ravi on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Pin.h"

@implementation Pin{
    
}

@synthesize mAuthor;
@synthesize mCommentArray;

- (void) encodeWithCoder:(NSCoder *)aCoder{

    [aCoder encodeObject:mAuthor forKey:@"mAuthor"];
    [aCoder encodeObject:mCommentArray forKey:@"mCommentArray"];
}
- (id) initWithCoder:(NSCoder *)aDecoder{
    [self setMAuthor:[aDecoder decodeObjectForKey:@"mAuthor"]];
    [self setMCommentArray:[aDecoder decodeObjectForKey:@"mCommentArray"]];
    return self;
}

@end
