//
//  SCNetworkModelResponseParser.h
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/9/4.
//

#import "SCNetworkJsonResponseParser.h"

FOUNDATION_EXPORT NSString *const SCNJsonParserErrorKey_ModelName;

@protocol SCNetworkModelParserProtocol <NSObject>

@required
+ (id)JSON2Model:(id)json modelName:(NSString *)mName refObj:(id)refObj;

@end


@interface SCNetworkModelResponseParser : SCNetworkJsonResponseParser

@property (nonatomic, copy) NSString *modelName;
// for JSONUtil
@property (nonatomic, strong) id refObj;

+ (void)registerModelParser:(Class<SCNetworkModelParserProtocol>)parser;
+ (Class<SCNetworkModelParserProtocol>)modelParser;

@end
