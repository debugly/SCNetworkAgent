//
//  SCNetworkPostApiProtocol.h
//  SCNetworkAgent
//
//  Created by Matt Reach on 2020/10/29.
//

#import "SCNetworkApiProtocol.h"

typedef enum : NSUInteger {
    SCNetworkURLEncodingBody,
    SCNetworkJSONEncodingBody,
    SCNetworkPlistEncodingBody,
    SCNetworkFormDataEncodingBody,
} SCNetworkBodyEncoding;

@protocol SCNetworkPostApiProtocol <SCNetworkApiProtocol>

@required
//默认是: application/x-www-form-urlencoded
- (SCNetworkBodyEncoding)bodyEncoding;
@optional
/**
 HTTP 请求体（body）参数
 */
- (NSDictionary*)bodyParameters;

@end
