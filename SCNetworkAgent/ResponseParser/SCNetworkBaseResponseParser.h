//
//  SCNetworkBaseResponseParser.h
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/9/4.
//

// 响应解析器；检查 HTTP 状态码 和 响应内容类型
// 1、默认情况下仅接受 [200,299] 之间的状态码
// 2、默认不检查 ContentTypes，如需检查可以设置成对应类型

#import <Foundation/Foundation.h>
#import "SCNetworkResponseParserProtocol.h"

FOUNDATION_EXPORT NSString *const SCNResponseParserErrorDomain;

@interface SCNetworkBaseResponseParser : NSObject<SCNetworkResponseParserProtocol>

@property (nonatomic, copy) NSIndexSet *acceptableStatusCodes;
@property (nonatomic, copy) NSSet <NSString *> *acceptableContentTypes;

+ (instancetype)parser;

@end
