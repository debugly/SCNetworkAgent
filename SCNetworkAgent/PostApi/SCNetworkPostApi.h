//
//  SCNetworkPostApi.h
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/8/31.
//
// 带 body 体的 POST 请求，如果没有 body 则使用 SCNetworkBaseApi 即可

#import "SCNetworkBaseApi.h"
#import "SCNetworkPostApiProtocol.h"

@interface SCNetworkPostApi : SCNetworkBaseApi<SCNetworkPostApiProtocol>

//默认是: application/x-www-form-urlencoded
@property(nonatomic,assign) SCNetworkBodyEncoding bodyEncoding;

/**
 HTTP 请求体参数
 */
@property(nonatomic,strong) NSDictionary* bodyParameters;

@end
