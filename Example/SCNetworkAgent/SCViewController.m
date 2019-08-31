//
//  SCViewController.m
//  SCNetworkAgent
//
//  Created by MRFoundation on 08/30/2019.
//  Copyright (c) 2019 MRFoundation. All rights reserved.
//

#import "SCViewController.h"
#import <SCNetworkAgent/SCNetworkAgent.h>
#import <SCNetworkAgent/SCNetworkBaseApi.h>
#import <SCNetworkAgent/SCNetworkPostApi.h>
#import <SCNetworkAgent/SCNetworkDownloadApi.h>
#import <SCNetworkAgent/SCNetworkUploadApi.h>
#import "SCNetworkApiExecutor.h"

@interface SCViewController ()

@end

@implementation SCViewController

- (void)testBaseApiGet {
    SCNetworkBaseApi *api = [SCNetworkBaseApi new];
    api.method = SCNetworkHttpMethod_GET;
    api.urlString = @"http://localhost:3000/json/Video.json";
    api.queryParameters = @{@"k1":@"v1",@"k2":@"v2"};
    api.handler = ^(NSObject<SCNetworkBaseApiProtocol> *api, id result, NSError *err){
        if (!err) {
            NSLog(@"api suceed:%@",result);
        } else {
            NSLog(@"api failed:%@",err);
        }
    };
    
    [[SCNetworkAgent sharedAgent] execApi:api];
}

- (void)testBaseApiPost {
    SCNetworkBaseApi *api = [SCNetworkBaseApi new];
    api.method = SCNetworkHttpMethod_POST;
    api.urlString = @"http://localhost:3000/json/Video.json";
    api.queryParameters = @{@"k1":@"v1",@"k2":@"v2"};
    api.handler = ^(NSObject<SCNetworkBaseApiProtocol> *api, id result, NSError *err){
        if (!err) {
            NSLog(@"api suceed:%@",result);
        } else {
            NSLog(@"api failed:%@",err);
        }
    };
    
    [[SCNetworkAgent sharedAgent] execApi:api];
}

- (void)testUploadApi {
    
    SCNetworkUploadApi *uploadApi = [SCNetworkUploadApi new];
    uploadApi.urlString = @"http://localhost:3000/upload-file";
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
    
    uploadApi.handler = ^(NSObject<SCNetworkBaseApiProtocol> *api, id result, NSError *err){
        if (!err) {
            NSLog(@"upload file suceed:%@",api);
        } else {
            NSLog(@"upload file failed:%@",err);
        }
    };
    [[SCNetworkAgent sharedAgent] execApi:uploadApi];
}

- (void)testDownloadApi {
    SCNetworkDownloadApi *downApi = [SCNetworkDownloadApi new];
    downApi.method = SCNetworkHttpMethod_GET;
    downApi.urlString = @"http://localhost:3000/images/node.jpg";
    downApi.queryParameters = @{@"k1":@"v1",@"k2":@"v2"};
    NSString * downloadFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"node.jpg"];
    downApi.downloadFilePath = downloadFilePath;
    downApi.handler = ^(NSObject<SCNetworkBaseApiProtocol> *api, id result, NSError *err){
        if (!err) {
            NSLog(@"download file suceed:%@",api);
        } else {
            NSLog(@"download file failed:%@",err);
        }
    };
    [[SCNetworkAgent sharedAgent] execApi:downApi];
}

- (void)testPostApi {
    SCNetworkPostApi *postApi = [SCNetworkPostApi new];
    postApi.method = SCNetworkHttpMethod_POST;
    postApi.urlString = @"http://localhost:3000/users";
    postApi.queryParameters = @{@"name":@"Matt Reach",@"k1":@"v1",@"k2":@"v2"};
    postApi.bodyParameters = @{@"date":[[NSDate new]description]};
    postApi.parametersEncoding = SCNetworkPostEncodingFormData;
    postApi.handler = ^(NSObject<SCNetworkBaseApiProtocol> *api, id result, NSError *err){
        if (!err) {
            NSLog(@"postApi suceed:%@",result);
        } else {
            NSLog(@"postApi failed:%@",err);
        }
    };
    [[SCNetworkAgent sharedAgent] execApi:postApi];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[SCNetworkAgent sharedAgent] injectExecutor:[SCNetworkApiExecutor class]];
    
//    [self testBaseApiGet];
//    [self testBaseApiPost];
//    [self testUploadApi];
//    [self testDownloadApi];
    [self testPostApi];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
