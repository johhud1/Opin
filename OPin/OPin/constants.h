//
//  constants.h
//  OPinProto
//
//  Created by John C Hudson and Bhaskar Ravi on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface constants : NSObject

+ (NSString*) getPinsFromDBURL;
+ (NSString*) getJSONFieldsKey;
+ (NSString*) getJSONLatKey;
+ (NSString*) getJSONLongKey;
+ (NSString*) createCommentDBURL;
//+ (NSString*) annotationPinIDKey;
+ (NSString*) getCommentsFromDBURL;
+ (NSString*) getJSONCommentKey;
+ (NSString*) getJSONAuthorKey;
+ (NSString*) deletePinFromDBURL;
+ (NSString*) deletePinSuccessResponse;

@end
