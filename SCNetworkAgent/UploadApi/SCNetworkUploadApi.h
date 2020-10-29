//
//  SCNetworkUploadApi.h
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/8/31.
//
// 使用 POST 表单上传文件；如果不需要传文件，使用 SCNetworkPostApi 即可

#import "SCNetworkPostApi.h"
#import "SCNetworkUploadApiProtocol.h"

@interface SCNetworkUploadApi : SCNetworkPostApi <SCNetworkUploadApiProtocol>

///表单数组，可传多个文件
@property (nonatomic, strong) NSArray <SCNetworkFormPart *>* formParts;
///固定是 SCNetworkFormDataEncodingBody(multipart/form-data);不能修改
- (SCNetworkBodyEncoding)bodyEncoding;

///监听上传进度
@property (nonatomic, copy) SCNetworkUploadProgressHandler progressHandler;

@end
