//
//  SCNetworkBaseApi.m
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/8/30.
//

#import "SCNetworkBaseApi.h"

@interface SCNetworkBaseApi()

@property (nonatomic, copy) void (^cancelHandler)(NSObject<SCNetworkApiProtocol> *);

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

- (void)registerCancelHandler:(void (^)(NSObject<SCNetworkApiProtocol> *))handler
{
    self.cancelHandler = handler;
}

@end
