//
//  SCNetworkAgent.h
//  SCNetworkAgent
//
//  Created by 许乾隆 on 2019/8/30.
//

#import <Foundation/Foundation.h>
#import "SCNetworkApiProtocol.h"

@interface SCNetworkAgent : NSObject

+ (instancetype)sharedAgent;

- (void)execApi:(NSObject<SCNetworkBaseApiProtocol> *)api;

@end

@protocol SCNetworkApiExecutorProtocol <NSObject>

@required;
+ (BOOL)canProcessApi:(NSObject<SCNetworkBaseApiProtocol> *)api;
+ (void)doProcessApi:(NSObject<SCNetworkBaseApiProtocol> *)api;

@end

@interface SCNetworkAgent (Injection)

- (void)injectExecutor:(Class<SCNetworkApiExecutorProtocol>)executor;

@end
