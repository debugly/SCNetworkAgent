//
//  SCNetworkApiProtocol.h
//  SCNetworkAgent
//
//  Created by 许乾隆 on 2019/8/30.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SCNetworkHttpMethod_GET = 1,
    SCNetworkHttpMethod_POST
} SCNetworkHttpMethod;

typedef enum : NSUInteger {
    SCNetworkPostEncodingURL,
    SCNetworkPostEncodingJSON,
    SCNetworkPostEncodingPlist,
    SCNetworkPostEncodingFormData,
} SCNetworkPostEncoding;

@protocol SCNetworkFormFilePart<NSObject>

@property(nonatomic,copy) NSString *mime;//文本类型
@property(nonatomic,copy) NSString *fileName;//上传文件名
@property(nonatomic,copy) NSString *name;//表单的名称，默认为 "file"
///上传文件的时候，小文件可以使用 data，大文件要使用 fileURL，省得内存暂用过大！
@property(nonatomic,copy) NSString *fileURL;//文件地址，此时可以不传fileName和mime，内部自动推断
@property(nonatomic,strong) NSData *data;//二进制数据，必须传fileName和mime，内部不能推断

@end

@protocol SCNetworkBaseApiProtocol;
typedef void(^SCNetworkApiHandler)(NSObject<SCNetworkBaseApiProtocol> *api,id result,NSError *err);

@protocol SCNetworkBaseApiProtocol <NSObject>

@required;
/**
 HTTP 请求地址
 */
- (NSString *)urlString;
/**
 HTTP 请求方法，目前仅支持GET和POST
 */
- (SCNetworkHttpMethod)method;
/**
 HTTP 请求着陆回调
 */
- (SCNetworkApiHandler)handler;
/**
 取消掉请求
 */
- (void)cancel;

@optional;
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

@end

@protocol SCNetworkGetApiProtocol <SCNetworkBaseApiProtocol>

@end

@protocol SCNetworkPostApiProtocol <SCNetworkBaseApiProtocol>

@required;
//默认是: application/x-www-form-urlencoded
- (SCNetworkPostEncoding)parametersEncoding;
@optional;
/**
 HTTP 请求体参数
 */
- (NSDictionary*)bodyParameters;

@end


@protocol SCNetworkDownloadApiProtocol <SCNetworkBaseApiProtocol>

@required;
/**
 文件下载路径
 */
- (NSString *)downloadFilePath;

@end

@protocol SCNetworkUploadApiProtocol <SCNetworkPostApiProtocol>

@required;
//必须是: multipart/form-data
- (SCNetworkPostEncoding)parametersEncoding;

- (NSArray <NSObject<SCNetworkFormFilePart> *>*)formFileParts;

@end
