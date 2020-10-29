//
//  SCNetworkDownloadApi.h
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/8/30.
//
// 下载文件专用，支持断点续传

#import "SCNetworkBaseApi.h"
#import "SCNetworkDownloadApiProtocol.h"

@interface SCNetworkDownloadApi : SCNetworkBaseApi<SCNetworkDownloadApiProtocol>

///文件存储位置
@property (nonatomic, copy) NSString * downloadFilePath;
///下载进度
@property (nonatomic, copy) SCNetworkDownloadProgressHandler progressHandler;
///使用断点续传，默认不使用
@property (nonatomic, assign) BOOL useBreakpointContinuous;

@end
