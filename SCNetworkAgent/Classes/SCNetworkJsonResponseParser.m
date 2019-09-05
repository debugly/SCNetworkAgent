//
//  SCNetworkJsonResponseParser.m
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/9/4.
//

#import "SCNetworkJsonResponseParser.h"
#import "SCNetworkApiProtocol.h"

@implementation SCNetworkJsonResponseParser

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.autoRemovesNullValues = YES;
    }
    return self;
}

- (id)removeJSONNullValues:(id)JSONObject
{
    ///数组
    if ([JSONObject isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (id value in (NSArray *)JSONObject) {
            ///先处理下
            id handledValue = [self removeJSONNullValues:value];
            ///处理完毕后，不空就添加
            if (!handledValue || [handledValue isEqual:[NSNull null]]) {
                continue;
            }else{
                [mutableArray addObject:handledValue];
            }
        }
        return  [mutableArray copy];
    }
    ///字典
    else if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:JSONObject];
        for (id <NSCopying> key in [(NSDictionary *)JSONObject allKeys]) {
            
            id value = (NSDictionary *)JSONObject[key];
            
            if (!value || [value isEqual:[NSNull null]]) {
                [mutableDictionary removeObjectForKey:key];
            } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                id handledValue = [self removeJSONNullValues:value];;
                if (!handledValue || [handledValue isEqual:[NSNull null]]) {
                    continue;
                }else{
                    mutableDictionary[key] = handledValue;
                }
            }
        }
        return [mutableDictionary copy];
    }
    
    else if ((!JSONObject || [JSONObject isEqual:[NSNull null]])){
        return nil;
    }
    
    return JSONObject;
}

- (id)parser:(NSObject<SCNetworkBaseApiResponseProtocol> *)resp
       error:(NSError * __autoreleasing *)error
{
    ///检查数据是否为空
    NSData *data = [resp data];
    BOOL isSpace = [data isEqualToData:[NSData dataWithBytes:" " length:1]];
    
    if (data.length == 0 || isSpace)
    {
        if(error){
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey : @"zero data"
                                       };
            *error = [[NSError alloc] initWithDomain:@"com.sc.networkagent" code:NSURLErrorZeroByteResource userInfo:userInfo];
        }
        return nil;
    }
    
    ///数据不空，开始解析
    NSError *serializationError = nil;
    
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializationError];
    
    if (serializationError) {
        if(error){
            NSDictionary *userInfo = serializationError.userInfo;
            if (!userInfo) {
                userInfo = @{
                             NSLocalizedDescriptionKey : @"zero data"
                             };
            }
            *error = [[NSError alloc] initWithDomain:@"com.sc.networkagent" code:NSURLErrorCannotParseResponse userInfo:userInfo];
        }
        return nil;
    }
    
    ///正常解析，处理空值
    if (self.autoRemovesNullValues) {
        json = [self removeJSONNullValues:json];
    }
    
    //验证下服务器返回数据
    if (self.checkKeyPath && self.okValue) {
        if ([json isKindOfClass:[NSDictionary class]]) {
            id v = [json valueForKeyPath:self.checkKeyPath];
            BOOL isValidate = [[v description] isEqualToString:self.okValue];
            ///验证不通过
            if(!isValidate){
                if(error){
                    NSMutableDictionary *info = [NSMutableDictionary new];
                    [info setObject:@"json parser invalid" forKey:@"reason"];
                    [info setObject:self.checkKeyPath forKey:@"check keypath"];
                    [info setObject:self.okValue forKey:@"want value"];
                    [info setObject:v?v:@"nil" forKey:@"real value"];
                    NSDictionary *userInfo = @{
                                               NSLocalizedDescriptionKey : info
                                               };
                    *error = [[NSError alloc] initWithDomain:@"com.sc.networkagent" code:NSURLErrorCannotParseResponse userInfo:userInfo];
                }
                return nil;
            }
        } else {
            #if !defined(NS_BLOCK_ASSERTIONS)
            NSString *msg = [NSString stringWithFormat:@"unsupported json:[%@] for checkKeyPath:[%@] and okValue:[%@]",json,self.checkKeyPath,self.okValue];
            NSAssert(NO, msg);
            #endif
            return json;
        }
    }
    
    return json;
}

@end
