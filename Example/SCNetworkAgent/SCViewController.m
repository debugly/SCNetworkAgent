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
#import <SCNetworkAgent/SCNetworkApiResponseProtocol.h>

#import "SCApiExecutorForSCNetworkKit.h"
#import "SCApiExecutorForAFURLConnect.h"
#import "SCJson2ModelParser.h"
#import "VideoList.h"

@interface SCViewController ()

@property (nonatomic, strong) SCNetworkAgent * sharedAgent;

@end

@implementation SCViewController

- (NSString *)urlWithPath:(NSString *)path
{
    return [@"http://" stringByAppendingString:[HOST stringByAppendingPathComponent:path]];
}

- (IBAction)onClicked:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    if (tag == 1000) {
        [self testBaseApiGet];
    } else if (tag == 1001) {
        [self testBaseApiPost];
    } else if (tag == 1002) {
        [self testBaseApiGetModel];
    } else if (tag == 1003) {
        [self testUploadApi];
    } else if (tag == 1004) {
        [self testDownloadApi];
    } else if (tag == 1005) {
        [self testPostDownloadApi];
    } else if (tag == 1006) {
        [self testPostApi];
    } else if (tag == 1007) {
        [self testFormDataPostApi];
    } else if (tag == 1008) {
        [self testCancelApi];
    }
}


- (void)testBaseApiGet
{
    SCNetworkBaseApi *api = [SCNetworkBaseApi new];
    api.method = SCNetworkHttpMethod_GET;
    api.urlString = [self urlWithPath:@"/json/Video.json"];
    api.queryParameters = @{@"k1":@"v1",@"k2":@"v2"};
    SCNetworkJsonResponseParser *responseParser = [[SCNetworkJsonResponseParser alloc] init];
    responseParser.checkKeyPath = @"qq.code";
    responseParser.okValue = @"200";
    api.responseParser = responseParser;
    api.responseHandler = ^(NSObject<SCNetworkApiProtocol> *api, NSObject<SCNetworkApiResponseProtocol>* resp){
        if (!resp.err) {
            NSLog(@"get api suceed:%@",resp.parserResult);
        } else {
            NSAssert(NO, @"get api failed:%@",resp.err);
        }
    };
    
    [[self sharedAgent] execApi:api];
}

- (void)testBaseApiGetModel
{
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
    api.responseHandler = ^(NSObject<SCNetworkApiProtocol> *api, NSObject<SCNetworkApiResponseProtocol>* resp){
        if (!resp.err) {
            NSAssert([resp.parserResult isKindOfClass:[VideoList class]], @"model parser error!");
            NSLog(@"get api suceed:%@",resp.parserResult);
        } else {
            NSAssert(NO,@"get api failed:%@",resp.err);
        }
    };
    
    [[self sharedAgent] execApi:api];
}


/**
 BaseApi 可以发送Post请求，但是不支持body！需要支持可用 SCNetworkPostApi 。
 */
- (void)testBaseApiPost
{
    SCNetworkBaseApi *api = [SCNetworkBaseApi new];
    api.method = SCNetworkHttpMethod_POST;
    api.urlString = [self urlWithPath:@"/users"];
    api.queryParameters = @{@"k1":@"v1",@"k2":@"v2"};
    SCNetworkJsonResponseParser *responseParser = [[SCNetworkJsonResponseParser alloc] init];
    responseParser.checkKeyPath = @"status";
    responseParser.okValue = @"200";
    api.responseParser = responseParser;
    api.responseHandler = ^(NSObject<SCNetworkApiProtocol> *api, NSObject<SCNetworkApiResponseProtocol>* resp){
        if (!resp.err) {
            NSLog(@"post api suceed:%@",resp.parserResult);
        } else {
            NSAssert(NO,@"post api failed:%@",resp.err);
        }
    };
    
    [[self sharedAgent] execApi:api];
}

- (void)testPostApi
{
    SCNetworkPostApi *postApi = [SCNetworkPostApi new];
    postApi.method = SCNetworkHttpMethod_POST;
    postApi.urlString = [self urlWithPath:@"/users"];
    postApi.queryParameters = @{@"name":@"Matt Reach",@"k1":@"v1",@"k2":@"v2"};
    postApi.bodyParameters = @{@"date":[[NSDate new]description]};
    postApi.bodyEncoding = SCNetworkURLEncodingBody;
    SCNetworkJsonResponseParser *responseParser = [[SCNetworkJsonResponseParser alloc] init];
    responseParser.checkKeyPath = @"status";
    responseParser.okValue = @"200";
    postApi.responseParser = responseParser;
    
    postApi.responseHandler = ^(NSObject<SCNetworkApiProtocol> *api, NSObject<SCNetworkApiResponseProtocol>* resp){
        if (!resp.err) {
            NSLog(@"post api suceed:%@",resp.parserResult);
        } else {
            NSAssert(NO,@"post api failed:%@",resp.err);
        }
    };
    [[self sharedAgent] execApi:postApi];
}

- (void)testFormDataPostApi
{
    SCNetworkPostApi *postApi = [SCNetworkPostApi new];
    postApi.method = SCNetworkHttpMethod_POST;
    postApi.urlString = [self urlWithPath:@"/upload-file"];
    postApi.queryParameters = @{@"name":@"Matt Reach",@"k1":@"v1",@"k2":@"v2"};
    postApi.bodyParameters = @{@"date":[[NSDate new]description]};
    postApi.bodyEncoding = SCNetworkFormDataEncodingBody;
    SCNetworkJsonResponseParser *responseParser = [[SCNetworkJsonResponseParser alloc] init];
    responseParser.checkKeyPath = @"status";
    responseParser.okValue = @"200";
    postApi.responseParser = responseParser;
    
    postApi.responseHandler = ^(NSObject<SCNetworkApiProtocol> *api, NSObject<SCNetworkApiResponseProtocol>* resp){
        if (!resp.err) {
            NSLog(@"post api suceed:%@",resp.parserResult);
        } else {
            NSAssert(NO,@"post api failed:%@",resp.err);
        }
    };
    [[self sharedAgent] execApi:postApi];
}

- (void)testUploadApi
{
    SCNetworkUploadApi *uploadApi = [SCNetworkUploadApi new];
    uploadApi.urlString = [self urlWithPath:@"/upload-file"];
    uploadApi.queryParameters = @{@"k1":@"v1",@"k2":@"v2"};
    uploadApi.bodyParameters = @{@"bk1":@"bv1",@"bk2":@"bv2"};
    
    SCNetworkFormPart *filePart = [SCNetworkFormPart new];
    NSString *fileURL = [[NSBundle mainBundle]pathForResource:@"node" ofType:@"jpg"];
    filePart.data = [[NSData alloc]initWithContentsOfFile:fileURL];
    filePart.name = @"node";
    filePart.fileName = @"node.jpg";
    filePart.mime = @"image/jpg";
    
    SCNetworkFormPart *filePart2 = [SCNetworkFormPart new];
    filePart2.filePath = [[NSBundle mainBundle]pathForResource:@"note" ofType:@"txt"];
    filePart2.name = @"node";
    filePart2.fileName = @"node.txt";
    filePart2.mime = @"text/plain";
    uploadApi.formParts = @[filePart,filePart2];
    
    SCNetworkJsonResponseParser *responseParser = [[SCNetworkJsonResponseParser alloc] init];
    responseParser.checkKeyPath = @"status";
    responseParser.okValue = @"200";
    uploadApi.responseParser = responseParser;
    
    uploadApi.responseHandler = ^(NSObject<SCNetworkApiProtocol> *api, NSObject<SCNetworkApiResponseProtocol>* resp){
        if (!resp.err) {
            NSLog(@"upload file suceed:%@",resp.parserResult);
        } else {
            NSAssert(NO,@"upload file failed:%@",resp.err);
        }
    };
    [[self sharedAgent] execApi:uploadApi];
}

- (void)testDownloadApi
{
    SCNetworkDownloadApi *downApi = [SCNetworkDownloadApi new];
//    downApi.urlString = [self urlWithPath:@"/images/node.jpg"];
    downApi.urlString = [self urlWithPath:@"/users/download"];
    downApi.queryParameters = @{@"k1":@"v1",@"k2":@"v2"};
    
    NSString * downloadFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"node.jpg"];
    downApi.downloadFilePath = downloadFilePath;
    downApi.useBreakpointContinuous = NO;
    NSLog(@"downloadFilePath:%@",downloadFilePath);
    downApi.progressHandler = ^(NSObject<SCNetworkApiProtocol> *api, int64_t thisTransfered, int64_t totalBytesTransfered, int64_t totalBytesExpected){
        NSLog(@"%lld-%lld-%lld;%0.4f",thisTransfered,totalBytesTransfered,totalBytesExpected,1.0 * totalBytesTransfered/totalBytesExpected);
    };
    
    downApi.responseHandler = ^(NSObject<SCNetworkApiProtocol> *api, NSObject<SCNetworkApiResponseProtocol>* resp){
        SCNetworkDownloadApi *downloadApi = (SCNetworkDownloadApi *)api;
        if (!resp.err) {
            NSLog(@"download file suceed:%@",downloadApi.downloadFilePath);
        } else {
            NSAssert(NO,@"download file failed:%@",resp.err);
        }
    };
    [[self sharedAgent] execApi:downApi];
}

- (void)testPostDownloadApi
{
    SCNetworkDownloadApi *downApi = [SCNetworkDownloadApi new];
    downApi.method = SCNetworkHttpMethod_POST;
    downApi.urlString = [self urlWithPath:@"/users/download"];
    downApi.queryParameters = @{@"k1":@"v1",@"k2":@"v2"};
    
    NSString * downloadFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"node.jpg"];
    downApi.downloadFilePath = downloadFilePath;
    downApi.useBreakpointContinuous = YES;
    NSLog(@"downloadFilePath:%@",downloadFilePath);
    downApi.progressHandler = ^(NSObject<SCNetworkApiProtocol> *api, int64_t thisTransfered, int64_t totalBytesTransfered, int64_t totalBytesExpected){
        NSLog(@"%lld-%lld-%lld;%0.4f",thisTransfered,totalBytesTransfered,totalBytesExpected,1.0 * totalBytesTransfered/totalBytesExpected);
    };
    
    downApi.responseHandler = ^(NSObject<SCNetworkApiProtocol> *api, NSObject<SCNetworkApiResponseProtocol>* resp){
        SCNetworkDownloadApi *downloadApi = (SCNetworkDownloadApi *)api;
        if (!resp.err) {
            NSLog(@"download file suceed:%@",downloadApi.downloadFilePath);
        } else {
            NSAssert(NO,@"download file failed:%@",resp.err);
        }
    };
    [[self sharedAgent] execApi:downApi];
}

- (void)testCancelApi
{
    SCNetworkBaseApi *api = [SCNetworkBaseApi new];
    api.method = SCNetworkHttpMethod_GET;
    api.urlString = @"http://debugly.cn/repository/test.json";
    api.queryParameters = @{@"k1":@"v1",@"k2":@"v2"};
    api.responseHandler = ^(NSObject<SCNetworkApiProtocol> *api, NSObject<SCNetworkApiResponseProtocol>* resp){
        NSAssert(NO,@"when cancel request not invoke here!");
    };
    
    [[self sharedAgent] execApi:api];
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
//        [SCNetworkAgent injectExecutor:[SCApiExecutorForAFURLConnect class]];
        [SCNetworkAgent injectExecutor:[SCApiExecutorForSCNetworkKit class]];
    }
    
    self.sharedAgent = [SCNetworkAgent new];
}

@end
