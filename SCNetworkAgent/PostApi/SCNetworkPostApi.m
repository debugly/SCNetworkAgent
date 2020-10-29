//
//  SCNetworkPostApi.m
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/8/31.
//

#import "SCNetworkPostApi.h"

@implementation SCNetworkPostApi

- (void)setMethod:(SCNetworkHttpMethod)method
{
    NSAssert(method == SCNetworkHttpMethod_POST, @"PostApi can't and needn't set other method except POST!");
}

- (SCNetworkHttpMethod)method
{
    return SCNetworkHttpMethod_POST;
}

@end
