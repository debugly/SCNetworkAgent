//
//  SCJson2ModelParser.m
//  SCNetworkAgent_Example
//
//  Created by 许乾隆 on 2019/9/5.
//  Copyright © 2019 MRFoundation. All rights reserved.
//

#import "SCJson2ModelParser.h"
#import <SCJSONUtil/SCJSONUtil.h>

@implementation SCJson2ModelParser

+ (id)fetchSubJSON:(id)json keyPath:(NSString *)keypath
{
    return SCFindJSONwithKeyPath(keypath, json);
}

+ (id)JSON2Model:(id)json modelName:(NSString *)mName refObj:(id)refObj
{
    return SCJSON2ModelV2(json, mName,refObj);
}

+ (id)JSON2StringValueJSON:(id)json
{
    return SCJSON2StringValueJSON(json);
}

@end
