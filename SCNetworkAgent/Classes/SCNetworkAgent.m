//
//  SCNetworkAgent.m
//  SCNetworkAgent
//
//  Created by 许乾隆 on 2019/8/30.
//

#import "SCNetworkAgent.h"

@interface SCNetworkAgent ()

@property (nonatomic, strong) NSArray *executors;

@end

@implementation SCNetworkAgent

+ (instancetype)sharedAgent
{
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)execApi:(NSObject<SCNetworkBaseApiProtocol> *)api
{
    for (Class<SCNetworkApiExecutorProtocol> clazz in self.executors) {
        if ([clazz respondsToSelector:@selector(canProcessApi:)]) {
            if ([clazz canProcessApi:api]) {
                [clazz doProcessApi:api];
                break;
            }
        }
    }
}

@end

@implementation SCNetworkAgent (Injection)

- (void)injectExecutor:(Class<SCNetworkApiExecutorProtocol>)executor
{
    if (executor) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:self.executors];
        [arr addObject:executor];
        self.executors = [arr copy];
    }
}

@end