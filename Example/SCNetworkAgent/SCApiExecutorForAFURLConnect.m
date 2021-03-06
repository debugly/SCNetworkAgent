//
//  SCApiExecutorForAFURLConnect.m
//  SCNetworkAgent_Example
//
//  Created by Matt Reach on 2020/8/17.
//  Copyright © 2020 MRFoundation. All rights reserved.
//

#import "SCApiExecutorForAFURLConnect.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <AFNetworking/AFURLRequestSerialization.h>

#import <SCNetworkAgent/SCNetworkApiResponseProtocol.h>
#import <SCNetworkAgent/SCNetworkPostApiProtocol.h>
#import <SCNetworkAgent/SCNetworkDownloadApiProtocol.h>
#import <SCNetworkAgent/SCNetworkUploadApiProtocol.h>
#import <SCNetworkAgent/SCNetworkBaseApiResponse.h>

#import "objc/runtime.h"

@implementation SCNetworkAgent (_afn)

static const void *af_operation_mag_addr;

- (AFHTTPRequestOperationManager *)afOperationManager
{
    return objc_getAssociatedObject(self, &af_operation_mag_addr);
}

- (void)setAf_OperationManager:(AFHTTPRequestOperationManager *)manager
{
    objc_setAssociatedObject(self, &af_operation_mag_addr, manager, OBJC_ASSOCIATION_RETAIN);
}

@end

@implementation SCApiExecutorForAFURLConnect

+ (BOOL)canProcessApi:(NSObject<SCNetworkApiProtocol> *)api
{
    SCNetworkHttpMethod httpMethod = [api method];
    
    if (httpMethod == SCNetworkHttpMethod_GET) {
        return YES;
    } else if  (httpMethod == SCNetworkHttpMethod_POST){
        return YES;
    } else {
        return NO;
    }
}

+ (void)doProcessApi:(NSObject<SCNetworkApiProtocol> *)api agent:(SCNetworkAgent *)sender
{
    //NSLog(@"SCApiExecutorForAFURLConnect 处理了请求:%@",api);
    
    NSDictionary *header = [api header];
    NSDictionary *queryParams = [api queryParameters];
    NSString *ua  = [api userAgent];
    NSString *url = [api urlString];
    SCNetworkHttpMethod httpMethod = [api method];
    
    NSMutableURLRequest *request = nil;
    
    if ([api conformsToProtocol:@protocol(SCNetworkUploadApiProtocol)]) {
        
        NSAssert(httpMethod == SCNetworkHttpMethod_POST, @"Upload must use Http Post!");
        
        NSObject <SCNetworkUploadApiProtocol> *uploadApi = (id)api;
        
        NSAssert([uploadApi bodyEncoding] == SCNetworkFormDataEncodingBody, @"Upload must use FormData Encoding!");
        NSString *query = AFQueryStringFromParameters(queryParams);
        if ([url containsString:@"?"]) {
            url = [url stringByAppendingFormat:@"&%@",query];
        } else {
            url = [url stringByAppendingFormat:@"?%@",query];
        }
        
        if ([[uploadApi formParts] count] > 0) {
            request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:[uploadApi bodyParameters] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                for (SCNetworkFormPart *part in [uploadApi formParts]) {
                    if (part.data) {
                        if (part.fileName && part.mime) {
                            [formData appendPartWithFileData:part.data name:part.name fileName:part.fileName mimeType:part.mime];
                        } else {
                            [formData appendPartWithFormData:part.data name:part.name];
                        }
                    } else {
                        [formData appendPartWithFileURL:[NSURL fileURLWithPath:part.filePath] name:part.name fileName:part.fileName mimeType:part.mime error:nil];
                    }
                }
            } error:nil];
        } else {
            NSLog(@"Warning:upload none file or data!");
        }
    } else if ([api conformsToProtocol:@protocol(SCNetworkDownloadApiProtocol)]) {
        NSObject <SCNetworkDownloadApiProtocol> *downloadApi = (id)api;
        NSAssert(downloadApi.downloadFilePath.length != 0, @"download must has downloadFilePath!");
        request = [[AFHTTPRequestSerializer serializer] requestWithMethod: httpMethod == SCNetworkHttpMethod_GET ? @"GET" : @"POST" URLString:url parameters:queryParams error:nil];
        
    } else if ([api conformsToProtocol:@protocol(SCNetworkPostApiProtocol)]) {
        NSAssert(httpMethod == SCNetworkHttpMethod_POST, @"SCNetworkPostApiProtocol must use Http Post!");
        NSObject <SCNetworkPostApiProtocol> *postApi = (id)api;
        NSDictionary *bodyParameters = [postApi bodyParameters];
        NSString *query = AFQueryStringFromParameters(queryParams);
        
        if ([url containsString:@"?"]) {
            url = [url stringByAppendingFormat:@"&%@",query];
        } else {
            url = [url stringByAppendingFormat:@"?%@",query];
        }
        
        AFHTTPRequestSerializer *serializer = nil;
        switch ([postApi bodyEncoding]) {
            case SCNetworkURLEncodingBody:
            {
                serializer = [AFHTTPRequestSerializer serializer];
            }
                break;
            case SCNetworkJSONEncodingBody:
            {
                serializer = [AFJSONRequestSerializer serializer];
            }
                break;
            case SCNetworkPlistEncodingBody:
            {
               serializer = [AFPropertyListRequestSerializer serializer];
            }
                break;
            case SCNetworkFormDataEncodingBody:
            {
                request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:bodyParameters constructingBodyWithBlock:nil error:nil];
            }
                break;
        }
        if (serializer) {
            request = [serializer requestWithMethod:@"POST" URLString:url parameters:bodyParameters error:nil];
        }
    } else if ([api conformsToProtocol:@protocol(SCNetworkApiProtocol)]) {

        if (httpMethod == SCNetworkHttpMethod_GET) {
            request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:url parameters:queryParams error:nil];
            
        } else if (httpMethod == SCNetworkHttpMethod_POST) {
            
            NSString *query = AFQueryStringFromParameters(queryParams);
            
            if ([url containsString:@"?"]) {
                url = [url stringByAppendingFormat:@"&%@",query];
            } else {
                url = [url stringByAppendingFormat:@"?%@",query];
            }
            
            request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
        }
    } else {
        NSAssert(NO, @"can't support the api:%@",api);
    }
    
    [request setAllHTTPHeaderFields:header];
    [request setValue:ua forHTTPHeaderField:@"User-Agent"];
    if (api.timeout > 0) {
        [request setTimeoutInterval:api.timeout];
    }
    AFHTTPRequestOperationManager * manager = [sender afOperationManager];
    if (!manager) {
        manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [sender setAf_OperationManager:manager];
    }
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation * _Nonnull operation, NSData * _Nullable responseObject) {
        SCNetworkBaseApiResponse *resp = [SCNetworkBaseApiResponse new];
        resp.statusCode = operation.response.statusCode;
        resp.expectedContentLength = [responseObject length];
        resp.allHeaderFields = operation.response.allHeaderFields;
        resp.data = responseObject;

        if (api.responseParser) {
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
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        if (error.code == NSURLErrorCancelled) {
            //ignore cancel!
            return;
        }
        
        SCNetworkBaseApiResponse *resp = [SCNetworkBaseApiResponse new];
        resp.statusCode = operation.response.statusCode;
        resp.err = error;
        
        if (api.responseHandler) {
            api.responseHandler(api,resp);
        }
    }];
    
    if ([api conformsToProtocol:@protocol(SCNetworkDownloadApiProtocol)]) {
        NSObject <SCNetworkDownloadApiProtocol> *downloadApi = (id)api;
        operation.isDownloadReq = YES;
        //避免 416 问题
        if (!downloadApi.useBreakpointContinuous) {
            [[NSFileManager defaultManager] removeItemAtPath:downloadApi.downloadFilePath error:nil];
        }
        operation.outputStream = [NSOutputStream outputStreamToFileAtPath:downloadApi.downloadFilePath append:downloadApi.useBreakpointContinuous];
        NSFileHandle *handler = [NSFileHandle fileHandleForWritingAtPath:downloadApi.downloadFilePath];
        NSString *range = [NSString stringWithFormat:@"bytes=%lld-",[handler seekToEndOfFile]];
        [request addValue:range forHTTPHeaderField:@"Range"];
        __weak NSObject <SCNetworkDownloadApiProtocol> *wsDownloadApi = downloadApi;
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead,   long long totalBytesExpectedToRead) {
            __strong NSObject <SCNetworkDownloadApiProtocol> *downloadApi = wsDownloadApi;
            if (downloadApi.progressHandler) {
                downloadApi.progressHandler(downloadApi,bytesRead,totalBytesRead,totalBytesExpectedToRead);
            }
        }];
    }
    
    __weak AFHTTPRequestOperation *wsOperation = operation;
    [api registerCancelHandler:^(NSObject<SCNetworkApiProtocol> *api) {
        __strong AFHTTPRequestOperation *operation = wsOperation;
        [operation cancel];
    }];
    
    [manager.operationQueue addOperation:operation];
}

@end
