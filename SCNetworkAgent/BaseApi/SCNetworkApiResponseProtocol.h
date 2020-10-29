//
//  SCNetworkApiResponseProtocol.h
//  Pods
//
//  Created by Matt Reach on 2020/10/29.
//

#import <Foundation/Foundation.h>

@protocol SCNetworkApiResponseProtocol <NSObject>

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
