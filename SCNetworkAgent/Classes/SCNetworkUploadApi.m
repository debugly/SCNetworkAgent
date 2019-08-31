//
//  SCNetworkUploadApi.m
//  SCNetworkAgent
//
//  Created by 许乾隆 on 2019/8/31.
//

#import "SCNetworkUploadApi.h"

@implementation SCNetworkUploadApi

- (void)setParametersEncoding:(SCNetworkPostEncoding)parametersEncoding
{
    NSAssert(parametersEncoding == SCNetworkPostEncodingFormData, @"UploadApi can't and needn't set other encoding except SCNetworkPostEncodingFormData!");
}

- (SCNetworkPostEncoding)parametersEncoding
{
    return SCNetworkPostEncodingFormData;
}

@end
