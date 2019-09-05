//
//  SCNetworkModelResponseParser.h
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/9/4.
//

#import "SCNetworkJsonResponseParser.h"

@protocol SCNetworkModelParserProtocol <NSObject>

@required;
+ (id)fetchSubJSON:(id)json keyPath:(NSString *)keypath;
+ (id)JSON2Model:(id)json modelName:(NSString *)mName refObj:(id)refObj;
+ (id)JSON2StringValueJSON:(id)json;

@end


@interface SCNetworkModelResponseParser : SCNetworkJsonResponseParser

@property (nonatomic,copy) NSString *modelName;
@property (nonatomic,copy) NSString *modelKeyPath;
// for JSONUtil
@property (nonatomic,strong) id refObj;

+ (void)registerModelParser:(Class<SCNetworkModelParserProtocol>)parser;

@end
