//
//  SCNetworkUploadApi.m
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/8/31.
//

#import "SCNetworkUploadApi.h"

@implementation SCNetworkUploadApi

- (void)setBodyEncoding:(SCNetworkBodyEncoding)bodyEncoding
{
    NSAssert(bodyEncoding == SCNetworkFormDataEncodingBody, @"UploadApi can't and needn't set other encoding except SCNetworkFormDataEncodingBody!");
}

- (SCNetworkBodyEncoding)bodyEncoding
{
    return SCNetworkFormDataEncodingBody;
}

@end
