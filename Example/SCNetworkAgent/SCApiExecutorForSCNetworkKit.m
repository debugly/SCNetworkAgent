//
//  SCApiExecutorForSCNetworkKit.m
//  SCNetworkAgent_Example
//
//  Created by 许乾隆 on 2019/8/31.
//  Copyright © 2019 MRFoundation. All rights reserved.
//

#import "SCApiExecutorForSCNetworkKit.h"
#import <SCNetworkKit/SCNetworkKit.h>
#import <SCNetworkAgent/SCNetworkBaseApiResponse.h>
#import "objc/runtime.h"

@implementation SCNetworkAgent (_scn)

static const void *scn_service_addr;

- (SCNetworkService *)scn_service
{
    return objc_getAssociatedObject(self, &scn_service_addr);
}

- (void)setScn_service:(SCNetworkService *)service
{
    objc_setAssociatedObject(self, &scn_service_addr, service, OBJC_ASSOCIATION_RETAIN);
}

@end

@implementation SCApiExecutorForSCNetworkKit

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

+ (void)doProcessApi:(NSObject<SCNetworkBaseApiProtocol> *)api agent:(SCNetworkAgent *)sender
{
    NSLog(@"SCApiExecutorForSCNetworkKit 处理了请求:%@",api);
    
    SCNetworkRequest *req = nil;
    
    NSDictionary *header = [api header];
    NSDictionary *queryParams = [api queryParameters];
    NSString *ua = [api userAgent];
    NSString *url = [api urlString];
    SCNetworkHttpMethod httpMethod = [api method];
    
    if ([api conformsToProtocol:@protocol(SCNetworkUploadApiProtocol)]) {
        NSAssert(httpMethod == SCNetworkHttpMethod_POST, @"Upload must use Http Post!");
        NSObject <SCNetworkUploadApiProtocol> *uploadApi = (id)api;
        NSDictionary *bodyParameters = [uploadApi bodyParameters];
        SCNetworkPostRequest *postReq = [[SCNetworkPostRequest alloc] initWithURLString:url params:bodyParameters];
        if (queryParams) {
            [postReq addQueryParameters:queryParams];
        }
        [postReq addProgressChangedHandler:^(SCNetworkRequest *request, int64_t thisTransfered, int64_t totalBytesTransfered, int64_t totalBytesExpected) {
            if ([uploadApi respondsToSelector:@selector(progressHandler)] && uploadApi.progressHandler) {
                uploadApi.progressHandler(uploadApi,thisTransfered,totalBytesTransfered,totalBytesExpected);
            }
        }];
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
        NSObject <SCNetworkDownloadApiProtocol> *downloadApi = (id)api;
        
        SCNetworkDownloadRequest *downloadReq = [[SCNetworkDownloadRequest alloc] initWithURLString:url params:queryParams];
        downloadReq.method = httpMethod == SCNetworkHttpMethod_GET ? SCNetworkRequestGetMethod : SCNetworkRequestPostMethod;
        
        NSAssert(downloadApi.downloadFilePath.length != 0, @"download must has downloadFilePath!");
        
        downloadReq.downloadFileTargetPath = downloadApi.downloadFilePath;
        downloadReq.useBreakpointContinuous = downloadApi.useBreakpointContinuous;
        [downloadReq addProgressChangedHandler:^(SCNetworkRequest *request, int64_t thisTransfered, int64_t totalBytesTransfered, int64_t totalBytesExpected) {
            if ([downloadApi respondsToSelector:@selector(progressHandler)] && downloadApi.progressHandler) {
                downloadApi.progressHandler(downloadApi,thisTransfered,totalBytesTransfered,totalBytesExpected);
            }
        }];
        req = downloadReq;
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
                postReq.parameterEncoding = SCNPostDataEncodingURL;
            }
                break;
            case SCNetworkPostEncodingJSON:
            {
                postReq.parameterEncoding = SCNPostDataEncodingJSON;
            }
                break;
            case SCNetworkPostEncodingPlist:
            {
                postReq.parameterEncoding = SCNPostDataEncodingPlist;
            }
                break;
            case SCNetworkPostEncodingFormData:
            {
                postReq.parameterEncoding = SCNPostDataEncodingFormData;
            }
                break;
        }
        req = postReq;
    } else if ([api conformsToProtocol:@protocol(SCNetworkBaseApiProtocol)]) {
        if (httpMethod == SCNetworkHttpMethod_GET) {
            req = [[SCNetworkRequest alloc] initWithURLString:url params:queryParams];
        } else if (httpMethod == SCNetworkHttpMethod_POST) {
            SCNetworkPostRequest *postReq = [[SCNetworkPostRequest alloc] initWithURLString:url params:nil];
            if (queryParams) {
                [postReq addQueryParameters:queryParams];
            }
            postReq.parameterEncoding = SCNPostDataEncodingURL;
            req = postReq;
        }
    } else {
        NSAssert(NO, @"can't support the api:%@",api);
    }
    
    [req addHeaders:header];
    if (ua.length > 0) {
        [req addHeaders:@{@"User-Agent":ua}];
    }
    
    [req addCompletionHandler:^(SCNetworkRequest *request, NSData * result, NSError *err) {
        
        SCNetworkBaseApiResponse *resp = [SCNetworkBaseApiResponse new];
        resp.statusCode = request.response.statusCode;
        resp.expectedContentLength = [result length];
        resp.allHeaderFields = request.response.allHeaderFields;
        resp.data = result;

        if (err) {
            resp.err = err;
        } else if (api.responseParser) {
            NSError *parserErr = nil;
            BOOL httpOk = [api.responseParser validateResponse:resp error:&parserErr];
            if (httpOk) {
                id parserR = [api.responseParser parser:resp error:&parserErr];
                resp.parserResult = parserR;
            }
            resp.err = parserErr;
        }
        
        if (api.responseHandler) {
            api.responseHandler(api,resp);
        }
    }];
    
    [api registerCancelHandler:^(NSObject<SCNetworkBaseApiProtocol> *api) {
        [req cancel];
    }];
    
    req.responseParser = nil;
    
    SCNetworkService *service = [sender scn_service];
    if (!service) {
        service = [SCNetworkService new];
        [sender setScn_service:service];
    }
    [service startRequest:req];
}

@end
