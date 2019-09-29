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

- (id)parser:(NSObject<SCNetworkBaseApiResponseProtocol> *)resp error:(NSError *__autoreleasing *)error
{
    id json = [super parser:resp error:error];
    if (!json) {
        return nil;
    }
    
    if (!MParser) {
        NSAssert(NO, @"SCNModelResponseParser:使用前必须注册Model解析器！使用 registerModelParser 方法！");
    }
    
    id result = json;
    //查找目标JSON
    if (self.modelKeyPath.length > 0) {
        result = [MParser fetchSubJSON:result keyPath:self.modelKeyPath];
    }
    
    if (result) {
        if (self.modelName.length > 0) {
            //解析目标JSON
            result = [MParser JSON2Model:result modelName:self.modelName refObj:self.refObj];
        }else{
            //不需要解析为Model；
            result = [MParser JSON2StringValueJSON:result];
            //SCJSON2StringJOSN(result);
        }
    }else{
        ///如果传了error指针地址了
        if(error){
            ///result is nil;
            NSDictionary *info = @{@"reason":[NSString stringWithFormat:@"can't find target json for %@",self.modelName],
                                   @"origin":json};
            NSDictionary * userInfo = @{
                                        NSLocalizedDescriptionKey : info
                                        };
            *error = [[NSError alloc] initWithDomain:@"com.sc.networkagent" code:NSURLErrorCannotParseResponse userInfo:userInfo];
        }
    }
    return result;
}

@end
