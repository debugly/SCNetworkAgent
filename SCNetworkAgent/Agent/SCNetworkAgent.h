//
//  SCNetworkAgent.h
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/8/30.
//

#import <Foundation/Foundation.h>

@protocol SCNetworkApiProtocol;

@interface SCNetworkAgent : NSObject

/**
 所有网络请求通过这个方法，统一发出；
 便于上层面向切面 hook 等操作；
 */
- (void)execApi:(NSObject<SCNetworkApiProtocol> *)api;

@end

/**
 具体网络实现层需要实现 SCNetworkApiExecutorProtocol 协议；
 然后通过注册的方式，注入到 Agent 中，使得 Agent 与底层网络层解耦；
 */
@protocol SCNetworkApiExecutorProtocol <NSObject>

@required
+ (BOOL)canProcessApi:(NSObject<SCNetworkApiProtocol> *)api;
+ (void)doProcessApi:(NSObject<SCNetworkApiProtocol> *)api agent:(SCNetworkAgent *)sender;

@end

@interface SCNetworkAgent (Injection)

/**
 可注册多个 Executor，内部按顺序查找
 */
+ (void)injectExecutor:(Class<SCNetworkApiExecutorProtocol>)executor;

/**
 清空所有已注册的 Executor
 */
+ (void)clearAllExecutors;

@end
