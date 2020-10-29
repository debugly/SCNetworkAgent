//
//  SCNetworkResponseParserProtocol.h
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/9/4.
//

#import <Foundation/Foundation.h>

@protocol SCNetworkApiResponseProtocol;
@protocol SCNetworkResponseParserProtocol <NSObject>

@required

- (BOOL)validateResponse:(NSObject<SCNetworkApiResponseProtocol>*)response
                   error:(NSError * __autoreleasing *)error;

- (id)parser:(NSObject<SCNetworkApiResponseProtocol>*)resp
       error:(NSError * __autoreleasing *)error;

@end
