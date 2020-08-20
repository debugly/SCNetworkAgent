//
//  SCNetworkAgent.m
//  SCNetworkAgent
//
//  Created by 许乾隆 on 2019/8/30.
//

#import "SCNetworkAgent.h"

static NSArray *s_executors;

@implementation SCNetworkAgent

+ (instancetype)agent
{
    return [[self alloc] init];
}

- (void)execApi:(NSObject<SCNetworkBaseApiProtocol> *)api
{
    NSAssert([s_executors count] > 0, @"you must inject api executor before exec the api:%@",api);

    BOOL found = NO;
    for (Class<SCNetworkApiExecutorProtocol> clazz in [s_executors copy]) {
        if ([clazz respondsToSelector:@selector(canProcessApi:)]) {
            if ([clazz canProcessApi:api]) {
                [clazz doProcessApi:api agent:self];
                found = YES;
                break;
            }
        }
    }
    
    NSAssert(found, @"can't process the api:%@",api);
}

@end

@implementation SCNetworkAgent (Injection)

+ (void)injectExecutor:(Class<SCNetworkApiExecutorProtocol>)executor
{
    if (executor) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:s_executors];
        [arr addObject:executor];
        s_executors = [arr copy];
    }
}

@end
