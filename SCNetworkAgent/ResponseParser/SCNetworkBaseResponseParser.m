//
//  SCNetworkBaseResponseParser.m
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/9/4.
//

#import "SCNetworkBaseResponseParser.h"
#import "SCNetworkApiProtocol.h"
#import "SCNetworkApiResponseProtocol.h"

NSString *const SCNResponseParserErrorDomain = @"com.debugly.networkagent";

@implementation SCNetworkBaseResponseParser

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
    }
    return self;
}

- (BOOL)validateResponse:(NSObject<SCNetworkApiResponseProtocol>*)response
                   error:(NSError * __autoreleasing *)error
{
    BOOL responseIsValid = YES;
    NSError *validationError = nil;
    
    if (response && [response isKindOfClass:[NSHTTPURLResponse class]]) {
        
        if (self.acceptableContentTypes && ![self.acceptableContentTypes containsObject:[response MIMEType]]) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey : [NSString stringWithFormat:@"unacceptable content-type: %@", [response MIMEType]]
                                       };
            validationError = [[NSError alloc] initWithDomain:SCNResponseParserErrorDomain code:NSURLErrorCannotParseResponse userInfo:userInfo];

            responseIsValid = NO;
        }
        
        if (self.acceptableStatusCodes && ![self.acceptableStatusCodes containsIndex:(NSUInteger)response.statusCode]) {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Request failed: %ld", (long)[response statusCode]]
                                       };
            validationError = [[NSError alloc] initWithDomain:SCNResponseParserErrorDomain code:NSURLErrorBadServerResponse userInfo:userInfo];
            
            responseIsValid = NO;
        }
    }
    
    if (error && !responseIsValid) {
        *error = validationError;
    }
    
    return responseIsValid;
}

- (id)parser:(NSObject<SCNetworkApiResponseProtocol>*)resp error:(NSError *__autoreleasing *)error
{
    return resp.data;
}

+ (instancetype)parser
{
    return [[self alloc] init];
}

@end
