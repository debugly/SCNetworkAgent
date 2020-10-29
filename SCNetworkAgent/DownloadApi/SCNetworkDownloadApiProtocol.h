//
//  SCNetworkDownloadApiProtocol.h
//  SCNetworkAgent
//
//  Created by Matt Reach on 2020/10/29.
//

#import "SCNetworkApiProtocol.h"

@protocol SCNetworkDownloadApiProtocol;

//下载进度回调
typedef void(^SCNetworkDownloadProgressHandler)(NSObject<SCNetworkDownloadApiProtocol> * api, int64_t thisTransfered, int64_t totalBytesTransfered, int64_t totalBytesExpected);

@protocol SCNetworkDownloadApiProtocol <SCNetworkApiProtocol>

@required
/**
 文件下载路径
 */
- (NSString *)downloadFilePath;
///使用断点续传，默认不使用
@property (nonatomic, assign) BOOL useBreakpointContinuous;

@optional
/**
 下载进度回调
 */
- (SCNetworkDownloadProgressHandler)progressHandler;

@end
