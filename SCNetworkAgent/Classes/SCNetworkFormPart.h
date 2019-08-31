//
//  SCNetworkFormPart.h
//  SCNetworkAgent
//
//  Created by 许乾隆 on 2019/8/31.
//

#import <Foundation/Foundation.h>

@interface SCNetworkFormPart : NSObject

@property(nonatomic,copy) NSString *mime;//文本类型
@property(nonatomic,copy) NSString *fileName;//上传文件名
@property(nonatomic,copy) NSString *name;//表单的名称，默认为 "file"
///上传文件的时候，小文件可以使用 data，大文件要使用 fileURL，省得内存暂用过大！
@property(nonatomic,copy) NSString *filePath;//文件地址，此时可以不传fileName和mime，内部自动推断
@property(nonatomic,strong) NSData *data;//二进制数据，必须传fileName和mime，内部不能推断

@end
