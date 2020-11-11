//
//  SCNetworkJsonResponseParser.m
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/9/4.
//

#import "SCNetworkJsonResponseParser.h"
#import "SCNetworkApiProtocol.h"
#import "SCNetworkApiResponseProtocol.h"

NSString *const SCNJsonParserErrorKey_OkValue = @"OkValue";
NSString *const SCNJsonParserErrorKey_CheckKeyPath = @"CheckKeyPath";
NSString *const SCNJsonParserErrorKey_RealValue = @"RealValue";
NSString *const SCNJsonParserErrorKey_RawJSON = @"RawJSON";
NSString *const SCNJsonParserErrorKey_ErrMsgValue = @"ErrMsgValue";

@implementation SCNetworkJsonResponseParser

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.autoRemovesNullValues = YES;
    }
    return self;
}

- (id)removeJSONNullValues:(id)json
{
    //数组
    if ([json isKindOfClass:[NSArray class]]) {
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (id value in (NSArray *)json) {
            //先处理下
            id handledValue = [self removeJSONNullValues:value];
            //处理完毕后，不空就添加
            if (!handledValue || [handledValue isEqual:[NSNull null]]) {
                continue;
            }else{
                [mutableArray addObject:handledValue];
            }
        }
        return  [mutableArray copy];
    }
    //字典
    else if ([json isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:json];
        for (id <NSCopying> key in [(NSDictionary *)json allKeys]) {
            
            id value = (NSDictionary *)json[key];
            
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
    
    else if ((!json || [json isEqual:[NSNull null]])){
        return nil;
    }
    
    return json;
}

- (id)findSubJSON:(NSDictionary *)json keyPath:(NSString *)keyPath
{
    if (!keyPath || keyPath.length == 0) {
        return json;
    }
    NSArray *pathArr = [keyPath componentsSeparatedByString:@"/"];
    return [self findSubJSON:json keyPathArr:pathArr];
}

- (id)findSubJSON:(NSDictionary *)json keyPathArr:(NSArray *)pathArr
{
    if (!json) {
        return nil;
    }
    if (!pathArr || pathArr.count == 0) {
        return json;
    }
    NSMutableArray *pathArr2 = [NSMutableArray arrayWithArray:pathArr];
    
    while ([pathArr2 firstObject] && [[pathArr2 firstObject] description].length == 0) {
        [pathArr2 removeObjectAtIndex:0];
    }
    if ([pathArr2 firstObject]) {
        json = [json objectForKey:[pathArr2 firstObject]];
        [pathArr2 removeObjectAtIndex:0];
        return [self findSubJSON:json keyPathArr:pathArr2];
    }else{
        return json;
    }
}

- (id)parser:(NSObject<SCNetworkApiResponseProtocol> *)resp
       error:(NSError * __autoreleasing *)error
{
    //检查数据是否为空
    NSData *data = [resp data];
    BOOL isSpace = [data isEqualToData:[NSData dataWithBytes:" " length:1]];
    
    if (data.length == 0 || isSpace)
    {
        if(error){
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"zero data."};
            *error = [[NSError alloc] initWithDomain:SCNResponseParserErrorDomain code:NSURLErrorZeroByteResource userInfo:userInfo];
        }
        return nil;
    }
    
    //数据不空，开始解析
    NSError *serializationError = nil;
    
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializationError];
    
    if (serializationError) {
        if(error){
            NSDictionary *userInfo = serializationError.userInfo;
            if (!userInfo) {
                userInfo = @{NSLocalizedDescriptionKey : @"parser data to json failed."};
            }
            *error = [[NSError alloc] initWithDomain:SCNResponseParserErrorDomain code:NSURLErrorCannotParseResponse userInfo:userInfo];
        }
        return nil;
    }
    
    //正常解析，处理空值
    if (self.autoRemovesNullValues) {
        json = [self removeJSONNullValues:json];
    }
    
    //验证下服务器返回数据
    if (self.checkKeyPath && self.okValue) {
        if ([json isKindOfClass:[NSDictionary class]]) {
            id v = [json valueForKeyPath:self.checkKeyPath];
            BOOL isValidate = [[v description] isEqualToString:self.okValue];
            //验证不通过
            if(!isValidate){
                if(error){
                    NSMutableDictionary *info = [NSMutableDictionary new];
                    [info setObject:[self.checkKeyPath stringByAppendingString:@" can't pass verify."] forKey:NSLocalizedDescriptionKey];
                    [info setObject:@"check value is not equal to the okValue." forKey:NSLocalizedFailureReasonErrorKey];
                    [info setObject:self.checkKeyPath forKey:SCNJsonParserErrorKey_CheckKeyPath];
                    [info setObject:self.okValue forKey:SCNJsonParserErrorKey_OkValue];
                    [info setObject:v?v:[NSNull null] forKey:SCNJsonParserErrorKey_RealValue];
                    [info setObject:json forKey:SCNJsonParserErrorKey_RawJSON];
                    if(self.errMsgKeyPath){
                        id message = [json objectForKey:self.errMsgKeyPath];
                        if(message){
                            [info setObject:message forKey:SCNJsonParserErrorKey_ErrMsgValue];
                        }
                    }
                    *error = [[NSError alloc] initWithDomain:SCNResponseParserErrorDomain code:NSURLErrorCannotParseResponse userInfo:info];
                }
                return nil;
            }
        } else {
            if (error) {
                NSMutableDictionary *info = [NSMutableDictionary new];
                NSString *msg = [NSString stringWithFormat:@"can't find checkKeyPath:[%@]",self.checkKeyPath];
                [info setObject:msg forKey:NSLocalizedDescriptionKey];
                [info setObject:msg forKey:NSLocalizedFailureReasonErrorKey];
                [info setObject:self.checkKeyPath forKey:SCNJsonParserErrorKey_CheckKeyPath];
                [info setObject:self.okValue forKey:SCNJsonParserErrorKey_OkValue];
                [info setObject:json forKey:SCNJsonParserErrorKey_RawJSON];
                *error = [[NSError alloc] initWithDomain:SCNResponseParserErrorDomain code:NSURLErrorCannotParseResponse userInfo:info];
            }
            return nil;
        }
    }
    
    //查找目标JSON
    if (self.targetKeyPath.length > 0) {
        json = [self findSubJSON:json keyPath:self.targetKeyPath];
    }
    
    if(!json){
        if (error && ! *error) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"can't find target json"};
            *error = [[NSError alloc] initWithDomain:SCNResponseParserErrorDomain code:NSURLErrorCannotParseResponse userInfo:userInfo];
        }
    }
    
    return json;
}

@end
