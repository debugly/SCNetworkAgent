//
//  SCNetworkApiProtocol.h
//  SCNetworkAgent
//
//  Created by 许乾隆 on 2019/8/30.
//

#import <Foundation/Foundation.h>
#import "SCNetworkFormPart.h"
#import "SCNetworkResponseParserProtocol.h"

typedef enum : NSUInteger {
    SCNetworkHttpMethod_GET,
    SCNetworkHttpMethod_POST
} SCNetworkHttpMethod;

typedef enum : NSUInteger {
    SCNetworkPostEncodingURL,
    SCNetworkPostEncodingJSON,
    SCNetworkPostEncodingPlist,
    SCNetworkPostEncodingFormData,
} SCNetworkPostEncoding;

@protocol SCNetworkBaseApiProtocol,SCNetworkBaseApiResponseProtocol;
//响应回调
typedef void(^SCNetworkApiResponseHandler)(NSObject<SCNetworkBaseApiProtocol> * api,NSObject<SCNetworkBaseApiResponseProtocol>* resp);
//上传、下载进度回调
typedef void(^SCNetworkApiProgressHandler)(NSObject<SCNetworkBaseApiProtocol> * api, int64_t thisTransfered, int64_t totalBytesTransfered, int64_t totalBytesExpected);

#pragma mark - SCNetworkBaseApiResponseProtocol

@protocol SCNetworkBaseApiResponseProtocol <NSObject>

@required
/**
 the HTTP status code
 */
- (NSInteger)statusCode;
/**
 all the HTTP header fields
 */
- (NSDictionary *)allHeaderFields;
/**
 the MIME type
 */
- (NSString *)MIMEType;
/**
 the expected content length
 */
- (long long)expectedContentLength;
/**
 the expected content
 */
- (NSData *)data;
/**
 the http error or parser error
 */
- (NSError *)err;
/**
 parser result
 */
- (id)parserResult;

@end

#pragma mark - SCNetworkBaseApiProtocol

@protocol SCNetworkBaseApiProtocol <NSObject>

@required
/**
 HTTP 请求地址
 */
- (NSString *)urlString;
/**
 HTTP 请求方法，目前仅支持GET和POST;
 POST 请求不支持body体；see SCNetworkPostApiProtocol;
 */
- (SCNetworkHttpMethod)method;
/**
 HTTP 请求着陆回调
 */
- (SCNetworkApiResponseHandler)responseHandler;

@optional
/**
 HTTP 请求参数，URL上带的参数
 */
- (NSDictionary*)queryParameters;

/**
 HTTP 请求Header参数
 */
- (NSDictionary*)header;

/**
 HTTP 请求UA，优先级大于httpHeader
 */
- (NSString *)userAgent;

/**
 取消掉请求
 */
- (void)cancel;

/**
 注册取消回调，当调用cancel时，该handler回调
 */
- (void)registerCancelHandler:(void(^)(NSObject <SCNetworkBaseApiProtocol>*api))handler;

/**
 响应解析器
 */
- (NSObject<SCNetworkResponseParserProtocol> *)responseParser;

@end

#pragma mark - SCNetworkPostApiProtocol

@protocol SCNetworkPostApiProtocol <SCNetworkBaseApiProtocol>

@required
//默认是: application/x-www-form-urlencoded
- (SCNetworkPostEncoding)parametersEncoding;
@optional
/**
 HTTP 请求体（body）参数
 */
- (NSDictionary*)bodyParameters;

@end

#pragma mark - SCNetworkUploadApiProtocol

@protocol SCNetworkUploadApiProtocol <SCNetworkPostApiProtocol>

@required
//必须是: multipart/form-data
- (SCNetworkPostEncoding)parametersEncoding;

- (NSArray <SCNetworkFormPart *>*)formParts;

@optional
/**
 上传进度回调
 */
- (SCNetworkApiProgressHandler)progressHandler;

@end

#pragma mark - SCNetworkDownloadApiProtocol

@protocol SCNetworkDownloadApiProtocol <SCNetworkBaseApiProtocol>

@required
/**
 文件下载路径
 */
- (NSString *)downloadFilePath;
///使用断点续传，默认不使用
@property (nonatomic, assign) BOOL useBreakpointContinuous;

@optional
/**
 下载进度回调
 */
- (SCNetworkApiProgressHandler)progressHandler;

@end
