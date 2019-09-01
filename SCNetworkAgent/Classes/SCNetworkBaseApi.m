//
//  SCNetworkBaseApi.m
//  SCNetworkAgent
//
//  Created by 许乾隆 on 2019/8/30.
//

#import "SCNetworkBaseApi.h"

@interface SCNetworkBaseApi()

@property (nonatomic, copy) void (^cancelHandler)(NSObject<SCNetworkBaseApiProtocol> *);

@end

@implementation SCNetworkBaseApi

/**
 取消掉请求
 */
- (void)cancel
{
    if (self.cancelHandler) {
        self.cancelHandler(self);
    }
}

- (void)registerCancelHandler:(void (^)(NSObject<SCNetworkBaseApiProtocol> *))handler
{
    self.cancelHandler = handler;
}

@end
