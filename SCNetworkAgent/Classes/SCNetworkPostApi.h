//
//  SCNetworkPostApi.h
//  SCNetworkAgent
//
//  Created by 许乾隆 on 2019/8/31.
//

#import "SCNetworkBaseApi.h"

@interface SCNetworkPostApi : SCNetworkBaseApi<SCNetworkPostApiProtocol>

//默认是: application/x-www-form-urlencoded
@property(nonatomic,assign) SCNetworkPostEncoding parametersEncoding;

/**
 HTTP 请求体参数
 */
@property(nonatomic,strong) NSDictionary* bodyParameters;

@end
