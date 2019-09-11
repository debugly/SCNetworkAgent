//
//  SCViewController.m
//  SCNetworkAgent
//
//  Created by MRFoundation on 08/30/2019.
//  Copyright (c) 2019 MRFoundation. All rights reserved.
//

//将 localhost 换成 localhost.charlesproxy.com 可用 charles 代理抓包。

#define USE_CHARLES 1

#if USE_CHARLES
    #define HOST @"localhost.charlesproxy.com:3000"
#else
    #define HOST @"localhost:3000"
#endif

#import "SCViewController.h"
#import <SCNetworkAgent/SCNetworkAgent.h>
#import <SCNetworkAgent/SCNetworkBaseApi.h>
#import <SCNetworkAgent/SCNetworkPostApi.h>
#import <SCNetworkAgent/SCNetworkDownloadApi.h>
#import <SCNetworkAgent/SCNetworkUploadApi.h>
#import <SCNetworkAgent/SCNetworkJsonResponseParser.h>
#import <SCNetworkAgent/SCNetworkModelResponseParser.h>
#import "SCNetworkApiExecutor.h"
#import "SCJson2ModelParser.h"
#import "VideoList.h"

@interface SCViewController ()

@end

@implementation SCViewController

- (NSString *)urlWithPath:(NSString *)path
{
    return [@"http://" stringByAppendingString:[HOST stringByAppendingPathComponent:path]];
}

- (void)testBaseApiGet {
    SCNetworkBaseApi *api = [SCNetworkBaseApi new];
    api.method = SCNetworkHttpMethod_GET;
    api.urlString = [self urlWithPath:@"/json/Video.json"];
    api.queryParameters = @{@"k1":@"v1",@"k2":@"v2"};
    SCNetworkJsonResponseParser *responseParser = [[SCNetworkJsonResponseParser alloc] init];
    responseParser.checkKeyPath = @"qq.code";
    responseParser.okValue = @"200";
    api.responseParser = responseParser;
    api.responseHandler = ^(NSObject<SCNetworkBaseApiProtocol> *api, NSObject<SCNetworkBaseApiResponseProtocol>* resp){
        if (!resp.err) {
            NSLog(@"get api suceed:%@",resp.parserResult);
        } else {
            NSLog(@"get api failed:%@",resp.err);
        }
    };
    
    [[SCNetworkAgent sharedAgent] execApi:api];
}

- (void)testBaseApiGetModel {
    SCNetworkBaseApi *api = [SCNetworkBaseApi new];
    api.method = SCNetworkHttpMethod_GET;
    api.urlString = [self urlWithPath:@"/json/Video.json"];
    api.queryParameters = @{@"k1":@"v1",@"k2":@"v2"};
    SCNetworkModelResponseParser *responseParser = [[SCNetworkModelResponseParser alloc] init];
    responseParser.checkKeyPath = @"qq.code";
    responseParser.okValue = @"200";
    responseParser.modelName = @"VideoList";
    responseParser.refObj = @{@"qq":@"videos"};
    api.responseParser = responseParser;
    api.responseHandler = ^(NSObject<SCNetworkBaseApiProtocol> *api, NSObject<SCNetworkBaseApiResponseProtocol>* resp){
        if (!resp.err) {
            NSLog(@"get api suceed:%@",resp.parserResult);
        } else {
            NSLog(@"get api failed:%@",resp.err);
        }
    };
    
    [[SCNetworkAgent sharedAgent] execApi:api];
}


/**
 BaseApi 可以发送Post请求，但是不支持body！需要支持可用 SCNetworkPostApi 。
 */
- (void)testBaseApiPost {
    SCNetworkBaseApi *api = [SCNetworkBaseApi new];
    api.method = SCNetworkHttpMethod_POST;
    api.urlString = [self urlWithPath:@"/users"];
    api.queryParameters = @{@"k1":@"v1",@"k2":@"v2"};
    SCNetworkJsonResponseParser *responseParser = [[SCNetworkJsonResponseParser alloc] init];
    responseParser.checkKeyPath = @"status";
    responseParser.okValue = @"200";
    api.responseParser = responseParser;
    api.responseHandler = ^(NSObject<SCNetworkBaseApiProtocol> *api, NSObject<SCNetworkBaseApiResponseProtocol>* resp){
        if (!resp.err) {
            NSLog(@"post api suceed:%@",resp.parserResult);
        } else {
            NSLog(@"post api failed:%@",resp.err);
        }
    };
    
    [[SCNetworkAgent sharedAgent] execApi:api];
}

- (void)testPostApi {
    SCNetworkPostApi *postApi = [SCNetworkPostApi new];
    postApi.method = SCNetworkHttpMethod_POST;
    postApi.urlString = [self urlWithPath:@"/users"];
    postApi.queryParameters = @{@"name":@"Matt Reach",@"k1":@"v1",@"k2":@"v2"};
    postApi.bodyParameters = @{@"date":[[NSDate new]description]};
    postApi.parametersEncoding = SCNetworkPostEncodingURL;
    SCNetworkJsonResponseParser *responseParser = [[SCNetworkJsonResponseParser alloc] init];
    responseParser.checkKeyPath = @"status";
    responseParser.okValue = @"200";
    postApi.responseParser = responseParser;
    
    postApi.responseHandler = ^(NSObject<SCNetworkBaseApiProtocol> *api, NSObject<SCNetworkBaseApiResponseProtocol>* resp){
        if (!resp.err) {
            NSLog(@"post api suceed:%@",resp.parserResult);
        } else {
            NSLog(@"post api failed:%@",resp.err);
        }
    };
    [[SCNetworkAgent sharedAgent] execApi:postApi];
}

- (void)testFormDataPostApi {
    SCNetworkPostApi *postApi = [SCNetworkPostApi new];
    postApi.method = SCNetworkHttpMethod_POST;
    postApi.urlString = [self urlWithPath:@"/upload-file"];
    postApi.queryParameters = @{@"name":@"Matt Reach",@"k1":@"v1",@"k2":@"v2"};
    postApi.bodyParameters = @{@"date":[[NSDate new]description]};
    postApi.parametersEncoding = SCNetworkPostEncodingFormData;
    SCNetworkJsonResponseParser *responseParser = [[SCNetworkJsonResponseParser alloc] init];
    responseParser.checkKeyPath = @"status";
    responseParser.okValue = @"200";
    postApi.responseParser = responseParser;
    
    postApi.responseHandler = ^(NSObject<SCNetworkBaseApiProtocol> *api, NSObject<SCNetworkBaseApiResponseProtocol>* resp){
        if (!resp.err) {
            NSLog(@"post api suceed:%@",resp.parserResult);
        } else {
            NSLog(@"post api failed:%@",resp.err);
        }
    };
    [[SCNetworkAgent sharedAgent] execApi:postApi];
}

- (void)testUploadApi {
    
    SCNetworkUploadApi *uploadApi = [SCNetworkUploadApi new];
    uploadApi.urlString = [self urlWithPath:@"/upload-file"];
    uploadApi.queryParameters = @{@"k1":@"v1",@"k2":@"v2"};
    uploadApi.bodyParameters = @{@"bk1":@"bv1",@"bk2":@"bv2"};
    
    SCNetworkFormPart *filePart = [SCNetworkFormPart new];
    NSString *fileURL = [[NSBundle mainBundle]pathForResource:@"node" ofType:@"jpg"];
    filePart.data = [[NSData alloc]initWithContentsOfFile:fileURL];
    filePart.fileName = @"node.jpg";
    filePart.mime = @"image/jpg";
    filePart.name = @"node";
    
    SCNetworkFormPart *filePart2 = [SCNetworkFormPart new];
    filePart2.filePath = [[NSBundle mainBundle]pathForResource:@"note" ofType:@"txt"];
    
    uploadApi.formParts = @[filePart,filePart2];
    
    SCNetworkJsonResponseParser *responseParser = [[SCNetworkJsonResponseParser alloc] init];
    responseParser.checkKeyPath = @"status";
    responseParser.okValue = @"200";
    uploadApi.responseParser = responseParser;
    
    uploadApi.responseHandler = ^(NSObject<SCNetworkBaseApiProtocol> *api, NSObject<SCNetworkBaseApiResponseProtocol>* resp){
        if (!resp.err) {
            NSLog(@"upload file suceed:%@",resp.parserResult);
        } else {
            NSLog(@"upload file failed:%@",resp.err);
        }
    };
    [[SCNetworkAgent sharedAgent] execApi:uploadApi];
}

- (void)testDownloadApi {
    SCNetworkDownloadApi *downApi = [SCNetworkDownloadApi new];
    downApi.method = SCNetworkHttpMethod_GET;
    downApi.urlString = [self urlWithPath:@"/images/node.jpg"];
    downApi.queryParameters = @{@"k1":@"v1",@"k2":@"v2"};
    NSString * downloadFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"node.jpg"];
    downApi.downloadFilePath = downloadFilePath;
    
    downApi.progressHandler = ^(NSObject<SCNetworkBaseApiProtocol> *api, int64_t thisTransfered, int64_t totalBytesTransfered, int64_t totalBytesExpected){
        NSLog(@"%lld-%lld-%lld",thisTransfered,totalBytesTransfered,totalBytesExpected);
    };
    
    downApi.responseHandler = ^(NSObject<SCNetworkBaseApiProtocol> *api, NSObject<SCNetworkBaseApiResponseProtocol>* resp){
        if (!resp.err) {
            NSLog(@"download file suceed:%@",resp.parserResult);
        } else {
            NSLog(@"download file failed:%@",resp.err);
        }
    };
    [[SCNetworkAgent sharedAgent] execApi:downApi];
}

- (void)testCancelApi{
    SCNetworkBaseApi *api = [SCNetworkBaseApi new];
    api.method = SCNetworkHttpMethod_GET;
    api.urlString = @"http://debugly.cn/repository/test.json";
    api.queryParameters = @{@"k1":@"v1",@"k2":@"v2"};
    api.responseHandler = ^(NSObject<SCNetworkBaseApiProtocol> *api, NSObject<SCNetworkBaseApiResponseProtocol>* resp){
        if (!resp.err) {
            NSLog(@"get api suceed:%@",resp.parserResult);
        } else {
            NSLog(@"get api failed:%@",resp.err);
        }
    };
    
    [[SCNetworkAgent sharedAgent] execApi:api];
    //大致预估的时间，可适当调整，达到cancel的目的
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [api cancel];
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    {
        //!!!!!! 这是只是写个demo，实际项目中建议放到App启动之后，避免使用的时候找不到解析器 !!!!!!
        //使用Model响应解析器前，必须注入model解析器类！！!
        [SCNetworkModelResponseParser registerModelParser:[SCJson2ModelParser class]];
        //SCNetworkAgent 只是网络请求的协议层，因此需要注入实际的执行者才能发送请求！
        [[SCNetworkAgent sharedAgent] injectExecutor:[SCNetworkApiExecutor class]];
    }
    
//    [self testBaseApiGet];
//    [self testBaseApiGetModel];
//    [self testBaseApiPost];
//    [self testPostApi];
//    [self testFormDataPostApi];
//    [self testUploadApi];
    [self testDownloadApi];
//    [self testCancelApi];
}

@end
