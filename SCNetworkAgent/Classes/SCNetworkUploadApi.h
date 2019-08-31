//
//  SCNetworkUploadApi.h
//  SCNetworkAgent
//
//  Created by 许乾隆 on 2019/8/31.
//
// 上传必须是 POST，并且使用表单，

#import "SCNetworkPostApi.h"

@interface SCNetworkUploadApi : SCNetworkPostApi <SCNetworkUploadApiProtocol>

@property (nonatomic, strong) NSArray <SCNetworkFormPart *>* formParts;
//必须是: multipart/form-data
- (SCNetworkPostEncoding)parametersEncoding;

@end
