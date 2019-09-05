//
//  SCNetworkResponseParserProtocol.h
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/9/4.
//

#import <Foundation/Foundation.h>

@protocol SCNetworkBaseApiResponseProtocol;
@protocol SCNetworkResponseParserProtocol <NSObject>

@required;

- (BOOL)validateResponse:(NSObject<SCNetworkBaseApiResponseProtocol>*)response
                   error:(NSError * __autoreleasing *)error;

- (id)parser:(NSObject<SCNetworkBaseApiResponseProtocol>*)resp
       error:(NSError * __autoreleasing *)error;

@end
