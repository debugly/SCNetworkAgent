//
//  SCNetworkApiExecutor.h
//  SCNetworkAgent_Example
//
//  Created by 许乾隆 on 2019/8/31.
//  Copyright © 2019 MRFoundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCNetworkAgent.h"

@interface SCNetworkApiExecutor : NSObject <SCNetworkApiExecutorProtocol>

+ (BOOL)canProcessApi:(NSObject<SCNetworkBaseApiProtocol> *)api;
+ (void)doProcessApi:(NSObject<SCNetworkBaseApiProtocol> *)api;

@end
