//
//  model.h
//  OlderFaceTest
//
//  Created by pill on 2019/8/5.
//  Copyright © 2019 ppy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  身份证规则：  宽 > 高程5
 *  生日  第一个是四位数，第二三个是2位数  切他们的x 坐标在比例接近于1的位置上
 *  性别  男 女 以此类推民族在y坐标类似的位置一个汉字
 *  姓名行子且 位于最小坐标位置
 */
//碎片信息

@interface model : NSObject
@property (nonatomic,copy) NSString * info;//碎片包含的信息
@property (nonatomic,assign) CGRect rect;//碎片信息位置
@property (nonatomic,strong) UIImage * image;//碎片信息位置
@property (nonatomic,assign) int fixed;//碎片信息位置



@end


