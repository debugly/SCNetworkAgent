//
//  SCNetworkJsonResponseParser.h
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/9/4.
//

#import "SCNetworkBaseResponseParser.h"

@interface SCNetworkJsonResponseParser : SCNetworkBaseResponseParser

///default is YES
@property (nonatomic, assign) BOOL autoRemovesNullValues;

@property (nonatomic, copy) NSString *checkKeyPath;
@property (nonatomic, copy) NSString *okValue;

@end
