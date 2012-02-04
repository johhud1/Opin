//
//  constants.m
//  OPinProto
//
//  Created by John C Hudson and Bhaskar Ravi on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "constants.h"

@implementation constants

static NSString* getJSONFieldsKey = @"fields";
static NSString* pinsFromDB = @"/queryPins";
static NSString* latFromJSON = @"lat";
static NSString* longFromJSON = @"long";
static NSString* createCommentURL = @"/createComment/";
static NSString* annotationPinIDKey = @"pin_id";
static NSString* getCommentsFromDBURL = @"/getComments/";
static NSString* jsonCommentKey = @"comment";
static NSString* jsonAuthorKey = @"author";
static NSString* deletePinFromDBURL = @"/deletePin/";
static NSString* deletePinResponseSuccess = @"deletePin success";

+ (NSString*) deletePinSuccessResponse{
    return deletePinResponseSuccess;
}
+ (NSString*) deletePinFromDBURL{
    return deletePinFromDBURL;
}
+ (NSString*) getPinsFromDBURL{
    return pinsFromDB;
}
+ (NSString*) getCommentsFromDBURL{
    return getCommentsFromDBURL;
}
+ (NSString*) getJSONFieldsKey{
    return getJSONFieldsKey;
}
+(NSString*) getJSONLatKey{
    return latFromJSON;
}
+(NSString*) getJSONLongKey{
    return longFromJSON;
}
+(NSString*) createCommentDBURL{
    return createCommentURL;
}
+(NSString*) getAnnotationPinIDKey{
    return annotationPinIDKey;
}
+(NSString*) getJSONCommentKey{
    return jsonCommentKey;
}
+(NSString*) getJSONAuthorKey{
    return jsonAuthorKey;
}

@end
