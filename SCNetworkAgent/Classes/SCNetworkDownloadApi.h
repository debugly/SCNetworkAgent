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

@end
