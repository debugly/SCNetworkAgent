//
//  SCNetworkBaseResponseParser.h
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/9/4.
//

#import <Foundation/Foundation.h>
#import "SCNetworkResponseParserProtocol.h"

@interface SCNetworkBaseResponseParser : NSObject<SCNetworkResponseParserProtocol>

@property (nonatomic, copy, nullable) NSIndexSet *acceptableStatusCodes;
@property (nonatomic, copy, nullable) NSSet <NSString *> *acceptableContentTypes;

@end
