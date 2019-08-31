//
//  SCNetworkBaseApi.h
//  SCNetworkAgent
//
//  Created by 许乾隆 on 2019/8/30.
//

#import <Foundation/Foundation.h>
#import "SCNetworkApiProtocol.h"

@interface SCNetworkBaseApi : NSObject<SCNetworkBaseApiProtocol>

/**
 HTTP 请求地址
 */
@property (nonatomic, copy) NSString* urlString;

/**
 HTTP 请求方法，目前仅支持GET和POST
 */
@property (nonatomic, assign) SCNetworkHttpMethod method;

/**
 唯一标识（保留）
 */
- (NSString *)identifier;

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
@property (nonatomic, copy) SCNetworkApiHandler handler;

/**
 取消掉请求
 */
- (void)cancel;

@end
