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
#import <SCNetworkAgent/SCNetworkDownloadApi.h>
#import "SCNetworkApiExecutor.h"

@interface SCViewController ()

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[SCNetworkAgent sharedAgent] injectExecutor:[SCNetworkApiExecutor class]];
    
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
    
    SCNetworkDownloadApi *downApi = [SCNetworkDownloadApi new];
    downApi.method = SCNetworkHttpMethod_GET;
    downApi.urlString = @"http://localhost:3000/images/node.jpg";
    downApi.queryParameters = @{@"k1":@"v1",@"k2":@"v2"};
    NSString * downloadFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"node.jpg"];
    downApi.downloadFilePath = downloadFilePath;
    downApi.handler = ^(NSObject<SCNetworkBaseApiProtocol> *api, id result, NSError *err){
        if (!err) {
            NSLog(@"download file suceed:%@",downloadFilePath);
        } else {
            NSLog(@"download file failed:%@",err);
        }
    };
    [[SCNetworkAgent sharedAgent] execApi:downApi];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
