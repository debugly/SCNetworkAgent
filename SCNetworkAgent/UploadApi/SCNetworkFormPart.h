//
//  SCNetworkFormPart.h
//  SCNetworkAgent
//
//  Created by Matt Reach on 2019/8/31.
//

/**
 建议: 2M 以内的小文件使用 data；大文件一定使用 filePath；避免暂用过大内存！
 */

#import <Foundation/Foundation.h>

@interface SCNetworkFormPart : NSObject

/**
 文本类型
 */
@property(nonatomic, copy) NSString *mime;

/**
 上传文件名
 */
@property(nonatomic, copy) NSString *fileName;

/**
 表单的名称，默认为 "file"
 */
@property(nonatomic, copy) NSString *name;

/**
 文件地址，此时可以不传fileName和mime，内部根据文件名自动推断
 */
@property(nonatomic, copy) NSString *filePath;

/**
 二进制数据，必须传fileName和mime，内部不能推断
 */
@property(nonatomic, strong) NSData *data;

@end
