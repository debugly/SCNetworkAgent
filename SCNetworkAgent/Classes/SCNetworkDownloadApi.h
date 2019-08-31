//
//  SCNetworkDownloadApi.h
//  SCNetworkAgent
//
//  Created by 许乾隆 on 2019/8/30.
//

#import <SCNetworkAgent/SCNetworkBaseApi.h>

@interface SCNetworkDownloadApi : SCNetworkBaseApi<SCNetworkDownloadApiProtocol>

@property (nonatomic, copy) NSString* downloadFilePath;

@end
