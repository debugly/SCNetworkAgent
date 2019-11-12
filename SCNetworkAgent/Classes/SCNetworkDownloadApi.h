//
//  SCNetworkDownloadApi.h
//  SCNetworkAgent
//
//  Created by 许乾隆 on 2019/8/30.
//

#import "SCNetworkBaseApi.h"

@interface SCNetworkDownloadApi : SCNetworkBaseApi<SCNetworkDownloadApiProtocol>

@property (nonatomic, copy) NSString* downloadFilePath;
@property (nonatomic, copy) SCNetworkApiProgressHandler progressHandler;
///使用断点续传，默认不使用
@property (nonatomic, assign) BOOL useBreakpointContinuous;

@end
