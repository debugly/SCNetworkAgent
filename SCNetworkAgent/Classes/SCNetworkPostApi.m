//
//  SCNetworkPostApi.m
//  SCNetworkAgent
//
//  Created by 许乾隆 on 2019/8/31.
//

#import "SCNetworkPostApi.h"

@implementation SCNetworkPostApi

- (void)setMethod:(SCNetworkHttpMethod)method
{
    NSAssert(method == SCNetworkHttpMethod_POST, @"UploadApi can't and needn't set other method except post!");
}

- (SCNetworkHttpMethod)method
{
    return SCNetworkHttpMethod_POST;
}

@end
