//
//  SCNetworkBaseApiResponse.m
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/9/4.
//

#import "SCNetworkBaseApiResponse.h"

@implementation SCNetworkBaseApiResponse

- (NSString *)description
{
    return [NSString stringWithFormat:@"HTTP %ld, %@",self.statusCode,self.allHeaderFields];
}

@end
