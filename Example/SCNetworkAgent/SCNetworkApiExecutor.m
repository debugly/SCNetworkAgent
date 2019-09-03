//
//  SCNetworkApiExecutor.m
//  SCNetworkAgent_Example
//
//  Created by 许乾隆 on 2019/8/31.
//  Copyright © 2019 MRFoundation. All rights reserved.
//

#import "SCNetworkApiExecutor.h"
#import <SCNetworkKit/SCNetworkKit.h>

@implementation SCNetworkApiExecutor

+ (BOOL)canProcessApi:(NSObject<SCNetworkBaseApiProtocol> *)api
{
    SCNetworkHttpMethod httpMethod = [api method];
    
    if (httpMethod == SCNetworkHttpMethod_GET) {
        return YES;
    } else if  (httpMethod == SCNetworkHttpMethod_POST){
        return YES;
    } else {
        return NO;
    }
    
//    if ([api conformsToProtocol:@protocol(SCNetworkUploadApiProtocol)]) {
//        NSLog(@"UploadApi");
//    } else if ([api conformsToProtocol:@protocol(SCNetworkDownloadApiProtocol)]) {
//        NSLog(@"DownloadApi");
//    } else if ([api conformsToProtocol:@protocol(SCNetworkPostApiProtocol)]) {
//        NSLog(@"PostApi");
//    } else if ([api conformsToProtocol:@protocol(SCNetworkGetApiProtocol)]) {
//        NSLog(@"GetApi");
//    } else if ([api conformsToProtocol:@protocol(SCNetworkBaseApiProtocol)]) {
//        NSLog(@"BaseApi");
//    }
}

+ (void)doProcessApi:(NSObject<SCNetworkBaseApiProtocol> *)api
{
    NSLog(@"SCNetworkApiExecutor 处理了请求:%@",api);
    
    SCNetworkRequest *req = nil;
    
    NSDictionary *header = [api header];
    NSDictionary *queryParams = [api queryParameters];
    NSString *ua = [api userAgent];
    NSString *url = [api urlString];
    SCNetworkHttpMethod httpMethod = [api method];
    
    if ([api conformsToProtocol:@protocol(SCNetworkUploadApiProtocol)]) {
        NSLog(@"UploadApi");
        
        NSAssert(httpMethod == SCNetworkHttpMethod_POST, @"Upload must use Http Post!");
        NSObject <SCNetworkUploadApiProtocol> *uploadApi = (id)api;
        NSDictionary *bodyParameters = [uploadApi bodyParameters];
        SCNetworkPostRequest *postReq = [[SCNetworkPostRequest alloc] initWithURLString:url params:bodyParameters];
        if (queryParams) {
            [postReq addQueryParameters:queryParams];
        }
        
        NSAssert([uploadApi parametersEncoding] == SCNetworkPostEncodingFormData, @"Upload must use FormData Encoding!");
        
        if ([[uploadApi formParts] count] > 0) {
            NSMutableArray <SCNetworkFormFilePart *>* formFileParts = [NSMutableArray arrayWithCapacity:2];
            
            for (SCNetworkFormPart *part in [uploadApi formParts]) {
                SCNetworkFormFilePart *filePart = [SCNetworkFormFilePart new];
                filePart.mime = part.mime;
                filePart.fileName = part.fileName;
                filePart.name = part.name;
                filePart.fileURL = part.filePath;
                filePart.data = part.data;
                [formFileParts addObject:filePart];
            }
            
            postReq.formFileParts = [formFileParts copy];
            req = postReq;
        } else {
            NSLog(@"Warning:upload none file or data!");
        }
    } else if ([api conformsToProtocol:@protocol(SCNetworkDownloadApiProtocol)]) {
        NSAssert(httpMethod == SCNetworkHttpMethod_GET, @"download must use Http Get!");
        NSObject <SCNetworkDownloadApiProtocol> *downloadApi = (id)api;
#warning TODO download use http post!
        req = [[SCNetworkRequest alloc] initWithURLString:url params:queryParams];
        NSAssert(downloadApi.downloadFilePath.length != 0, @"download must has downloadFilePath!");
        req.downloadFileTargetPath = downloadApi.downloadFilePath;
    } else if ([api conformsToProtocol:@protocol(SCNetworkPostApiProtocol)]) {
        NSAssert(httpMethod == SCNetworkHttpMethod_POST, @"SCNetworkPostApiProtocol must use Http Post!");
        NSObject <SCNetworkPostApiProtocol> *postApi = (id)api;
        NSDictionary *bodyParameters = [postApi bodyParameters];
        SCNetworkPostRequest *postReq = [[SCNetworkPostRequest alloc] initWithURLString:url params:bodyParameters];
        if (queryParams) {
            [postReq addQueryParameters:queryParams];
        }

        switch ([postApi parametersEncoding]) {
            case SCNetworkPostEncodingURL:
            {
                postReq.parameterEncoding = SCNKParameterEncodingURL;
            }
                break;
            case SCNetworkPostEncodingJSON:
            {
                postReq.parameterEncoding = SCNKParameterEncodingJSON;
            }
                break;
            case SCNetworkPostEncodingPlist:
            {
                postReq.parameterEncoding = SCNKParameterEncodingPlist;
            }
                break;
            case SCNetworkPostEncodingFormData:
            {
                postReq.parameterEncoding = SCNKParameterEncodingFormData;
            }
                break;
        }
        req = postReq;
    } else if ([api conformsToProtocol:@protocol(SCNetworkBaseApiProtocol)]) {
        NSLog(@"BaseApi");
        if (httpMethod == SCNetworkHttpMethod_GET) {
            req = [[SCNetworkRequest alloc] initWithURLString:url params:queryParams];
        } else if (httpMethod == SCNetworkHttpMethod_POST) {
            SCNetworkPostRequest *postReq = [[SCNetworkPostRequest alloc] initWithURLString:url params:nil];
            if (queryParams) {
                [postReq addQueryParameters:queryParams];
            }
            postReq.parameterEncoding = SCNKParameterEncodingURL;
            req = postReq;
        }
    } else {
        NSAssert(NO, @"can't support the api:%@",api);
    }
    
    [req addHeaders:header];
    if (ua.length > 0) {
        [req addHeaders:@{@"User-Agent":ua}];
    }
    [req addCompletionHandler:^(SCNetworkRequest *request, id result, NSError *err) {
        if (api.handler) {
            api.handler(api,result,err);
        }
    }];
    
    [api registerCancelHandler:^(NSObject<SCNetworkBaseApiProtocol> *api) {
        [req cancel];
    }];
    
    req.responseParser = nil;
    [[SCNetworkService sharedService] startRequest:req];
}

@end