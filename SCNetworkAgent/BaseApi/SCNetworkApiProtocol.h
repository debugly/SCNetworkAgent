//
//  SCNetworkApiProtocol.h
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/8/30.
//

#import <Foundation/Foundation.h>
#import "SCNetworkFormPart.h"
#import "SCNetworkResponseParserProtocol.h"

typedef enum : NSUInteger {
    SCNetworkHttpMethod_GET,
    SCNetworkHttpMethod_POST
} SCNetworkHttpMethod;

@protocol SCNetworkApiProtocol,SCNetworkApiResponseProtocol;
//响应回调
typedef void(^SCNetworkApiResponseHandler)(NSObject<SCNetworkApiProtocol> * api,NSObject<SCNetworkApiResponseProtocol>* resp);

@protocol SCNetworkApiProtocol <NSObject>

@required
/**
 HTTP 请求地址
 */
- (NSString *)urlString;

/**
 HTTP 请求方法，目前仅支持GET和POST;
 POST 请求不支持body体；see SCNetworkPostApiProtocol;
 */
- (SCNetworkHttpMethod)method;

/**
 HTTP 请求着陆回调
 */
- (SCNetworkApiResponseHandler)responseHandler;

@optional
/**
 HTTP 请求参数，URL上带的参数
 */
- (NSDictionary*)queryParameters;

/**
 HTTP 请求Header参数
 */
- (NSDictionary*)header;

/**
 HTTP 请求UA，优先级大于httpHeader
 */
- (NSString *)userAgent;

/**
 取消掉请求
 */
- (void)cancel;

/**
 注册取消回调，当调用cancel时，该handler回调
 */
- (void)registerCancelHandler:(void(^)(NSObject <SCNetworkApiProtocol>*api))handler;

/**
 响应解析器
 */
- (NSObject<SCNetworkResponseParserProtocol> *)responseParser;

@end
