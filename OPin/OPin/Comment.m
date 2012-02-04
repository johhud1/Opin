//
//  Comment.m
//  mapProto
//
//  Created by John C Hudson and Bhaskar Ravi on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Comment.h"
@implementation Comment{
    
}

@synthesize mMessage;
@synthesize mAuthor;
@synthesize mTimestamp;

- (Comment*)initWithMessage:(NSString *)message author:(NSString *)author{
    Comment* comment = [Comment alloc];
    [comment setMMessage:message];
    [comment setMAuthor:author];
    [comment setMTimestamp:[NSDate date]];
    return comment;
}

- (void) encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:mAuthor forKey:@"mAuthor"];
    [aCoder encodeObject:mMessage forKey:@"mCommentArray"];
    [aCoder encodeObject:mTimestamp forKey:@"mTimeSstamp"];
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    [self setMAuthor:[aDecoder decodeObjectForKey:@"mAuthor"]];
    [self setMMessage:[aDecoder decodeObjectForKey:@"mCommentArray"]];
    [self setMTimestamp:[aDecoder decodeObjectForKey:@"mTimestamp"]];
    return self;
}

@end
