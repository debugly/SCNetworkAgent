//
//  SCNetworkModelResponseParser.m
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/9/4.
//

#import "SCNetworkModelResponseParser.h"
#import "SCNetworkApiProtocol.h"

NSString *const SCNJsonParserErrorKey_ModelName = @"ModelName";

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

- (id)parser:(NSObject<SCNetworkApiResponseProtocol> *)resp error:(NSError *__autoreleasing *)errp
{
    NSError *error = nil;
    id json = [super parser:resp error:&error];
    if (error) {
        if (errp) {
            *errp = error;
        }
        return nil;
    }
    
    if (self.modelName.length > 0) {
        if (!MParser) {
            NSAssert(NO, @"SCNetworkModelResponseParser:使用前必须注册Model解析器！使用 registerModelParser 方法！");
        }
        //解析目标JSON
        id model = [MParser JSON2Model:json modelName:self.modelName refObj:self.refObj];
        
        //model is nil ?
        if(!model){
            //传了errp 指针地址了?
            if(errp){
                NSDictionary *info = @{NSLocalizedDescriptionKey:@"can't convert target json to model",
                                       NSLocalizedFailureReasonErrorKey:@"can't convert target json to model",
                                       SCNJsonParserErrorKey_RawJSON:json,
                                       SCNJsonParserErrorKey_ModelName:self.modelName,
                };
                *errp = [[NSError alloc] initWithDomain:SCNResponseParserErrorDomain code:NSURLErrorCannotParseResponse userInfo:info];
            }
        }
        return model;
    } else {
        return json;
    }
}

@end
