//
//  SCNetworkModelResponseParser.m
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/9/4.
//

#import "SCNetworkModelResponseParser.h"
#import "SCNetworkApiProtocol.h"

static Class <SCNetworkModelParserProtocol> MParser;

@implementation SCNetworkModelResponseParser

+ (void)registerModelParser:(Class<SCNetworkModelParserProtocol>)parser
{
    MParser = parser;
}

+ (Class<SCNetworkModelParserProtocol>)modelParser
{
    return MParser;
}

- (id)parser:(NSObject<SCNetworkBaseApiResponseProtocol> *)resp error:(NSError *__autoreleasing *)errp
{
    NSError *error = nil;
    id json = [super parser:resp error:&error];
    if (error) {
        if (errp) {
            *errp = error;
        }
        return nil;
    }
    
    if (!MParser) {
        NSAssert(NO, @"SCNModelResponseParser:使用前必须注册Model解析器！使用 registerModelParser 方法！");
    }
    
    id result = json;
    if (result) {
        if (self.modelName.length > 0) {
            //解析目标JSON
            result = [MParser JSON2Model:result modelName:self.modelName refObj:self.refObj];
        }else{
            //不需要解析为Model；
            result = [MParser JSON2StringValueJSON:result];
            //SCJSON2StringJOSN(result);
        }
    }
    
    ///result is nil;
    if(!result){
        ///如果传了errp指针地址了
        if(errp){
            NSDictionary *info = @{NSLocalizedDescriptionKey:@"can't find target json",
                                   NSLocalizedFailureReasonErrorKey:[NSString stringWithFormat:@"can't find target json for %@",self.modelName],
                                   SCNJsonParserErrorKey_RawJSON:json};
            *errp = [[NSError alloc] initWithDomain:SCNResponseParserErrorDomain code:NSURLErrorCannotParseResponse userInfo:info];
        }
    }
    
    return result;
}

@end
