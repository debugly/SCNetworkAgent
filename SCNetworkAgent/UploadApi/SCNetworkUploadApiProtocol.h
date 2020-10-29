//
//  SCNetworkUploadApiProtocol.h
//  SCNetworkAgent
//
//  Created by Matt Reach on 2020/10/29.
//

#import "SCNetworkPostApiProtocol.h"

@protocol SCNetworkUploadApiProtocol;

//上传进度回调
typedef void(^SCNetworkUploadProgressHandler)(NSObject<SCNetworkUploadApiProtocol> * api, int64_t thisTransfered, int64_t totalBytesTransfered, int64_t totalBytesExpected);

@protocol SCNetworkUploadApiProtocol <SCNetworkPostApiProtocol>

@required
//必须是: multipart/form-data
- (SCNetworkBodyEncoding)bodyEncoding;

- (NSArray <SCNetworkFormPart *>*)formParts;

@optional
/**
 上传进度回调
 */
- (SCNetworkUploadProgressHandler)progressHandler;

@end
