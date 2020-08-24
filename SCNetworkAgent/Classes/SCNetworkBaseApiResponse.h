//
//  SCNetworkBaseApiResponse.h
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/9/4.
//

#import <Foundation/Foundation.h>
#import "SCNetworkApiProtocol.h"

@interface SCNetworkBaseApiResponse : NSObject<SCNetworkBaseApiResponseProtocol>

/**
 the HTTP status code
 */
@property (nonatomic, assign) NSInteger statusCode;
/**
 all the HTTP header fields
 */
@property (nonatomic, strong) NSDictionary * allHeaderFields;
/**
 the MIME type
 */
@property (nonatomic, strong) NSString * MIMEType;
/**
 the expected content length
 */
@property (nonatomic, assign) long long expectedContentLength;
/**
 the expected content
 */
@property (nonatomic, strong) NSData * data;
/**
 the http error or parser error
 */
@property (nonatomic, strong) NSError * err;
/**
 parser result
 */
@property (nonatomic, strong) id parserResult;

@end
