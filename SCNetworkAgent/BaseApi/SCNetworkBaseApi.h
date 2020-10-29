//
//  SCNetworkBaseApi.h
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/8/30.
//

// API 基类，实现了 最基本的 GET,POST(不支持body) 请求

// 可设置 Header
// 支持 block 响应着陆
// 支持配置响应解析器
// 支持取消

#import <Foundation/Foundation.h>
#import "SCNetworkApiProtocol.h"
#import "SCNetworkResponseParserProtocol.h"

@interface SCNetworkBaseApi : NSObject<SCNetworkApiProtocol>

/**
 HTTP 请求地址
 */
@property (nonatomic, copy) NSString* urlString;

/**
 HTTP 请求方法，目前仅支持GET和POST
 */
@property (nonatomic, assign) SCNetworkHttpMethod method;

/**
 HTTP 请求参数，URL上带的参数
 */
@property (nonatomic, strong) NSDictionary* queryParameters;

/**
 HTTP 请求Header参数
 */
@property (nonatomic, strong) NSDictionary* header;

/**
 HTTP 请求UA，优先级大于httpHeader
 */
@property (nonatomic, copy) NSString* userAgent;

/**
 HTTP 请求着陆回调
 */
@property (nonatomic, copy) SCNetworkApiResponseHandler responseHandler;

/**
 响应解析器
 */
@property (nonatomic, strong) NSObject<SCNetworkResponseParserProtocol> * responseParser;

/**
 取消掉请求
 */
- (void)cancel;

/**
 注册取消回调，当调用cancel时，该handler回调
 */
- (void)registerCancelHandler:(void(^)(NSObject <SCNetworkApiProtocol>*api))handler;


@end
