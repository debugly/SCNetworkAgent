//
//  SCNetworkJsonResponseParser.h
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/9/4.
//

#import "SCNetworkBaseResponseParser.h"

FOUNDATION_EXPORT NSString *const SCNJsonParserErrorKey_OkValue;
FOUNDATION_EXPORT NSString *const SCNJsonParserErrorKey_CheckKeyPath;
FOUNDATION_EXPORT NSString *const SCNJsonParserErrorKey_RealValue;
FOUNDATION_EXPORT NSString *const SCNJsonParserErrorKey_RawJSON;

@interface SCNetworkJsonResponseParser : SCNetworkBaseResponseParser

///default is YES
@property (nonatomic, assign) BOOL autoRemovesNullValues;

@property (nonatomic, copy) NSString *checkKeyPath;
@property (nonatomic, copy) NSString *okValue;
@property (nonatomic, copy) NSString *targetKeyPath;

@end
