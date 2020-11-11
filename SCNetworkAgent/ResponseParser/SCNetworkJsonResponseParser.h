//
//  SCNetworkJsonResponseParser.h
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/9/4.
//

// JSON 响应解析器；在父类的基础上，将响应解析成了 JSON 数据；
// 1、默认剔除 null 值
// 2、可设置检查路径 和 OK 值
// 3、可在检查值 OK 的情况下，提取目标值

/*
 {
 status: 200
 data: {
        xxx:666
    }
 }
 
 假如服务器返回的 json 是这个样子的，我们想要解析器帮忙检查 status 等于 200时，返回 data 的内容，
 则可以这么写：
 
 SCNetworkJsonResponseParser *parser = [SCNetworkJsonResponseParser new];
 parser.checkKeyPath = @"status";
 parser.okValue = @"200";
 parser.targetKeyPath = @"data";
 //记得赋值给你的 api
 yourApi.responseParser = parser;
 */

#import "SCNetworkBaseResponseParser.h"

//err.userInfo[key], blew is keys.
FOUNDATION_EXPORT NSString *const SCNJsonParserErrorKey_OkValue;
FOUNDATION_EXPORT NSString *const SCNJsonParserErrorKey_CheckKeyPath;
FOUNDATION_EXPORT NSString *const SCNJsonParserErrorKey_RealValue;
FOUNDATION_EXPORT NSString *const SCNJsonParserErrorKey_RawJSON;
FOUNDATION_EXPORT NSString *const SCNJsonParserErrorKey_ErrMsgValue;

@interface SCNetworkJsonResponseParser : SCNetworkBaseResponseParser

///default is YES
@property (nonatomic, assign) BOOL autoRemovesNullValues;
@property (nonatomic, copy) NSString *checkKeyPath;
@property (nonatomic, copy) NSString *okValue;
@property (nonatomic, copy) NSString *targetKeyPath;
///当checkKeyPath的值不等于okValue时，取errMsgKeyPath值；
@property (nonatomic, copy) NSString *errMsgKeyPath;

@end
