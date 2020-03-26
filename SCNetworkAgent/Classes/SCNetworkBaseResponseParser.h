//
//  SCNetworkBaseResponseParser.h
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/9/4.
//

#import <Foundation/Foundation.h>
#import "SCNetworkResponseParserProtocol.h"

FOUNDATION_EXPORT NSString *const SCNResponseParserErrorDomain;

@interface SCNetworkBaseResponseParser : NSObject<SCNetworkResponseParserProtocol>

@property (nonatomic, copy) NSIndexSet *acceptableStatusCodes;
@property (nonatomic, copy) NSSet <NSString *> *acceptableContentTypes;

+ (instancetype)parser;

@end
