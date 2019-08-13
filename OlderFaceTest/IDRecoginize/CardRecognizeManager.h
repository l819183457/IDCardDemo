//
//  CardRecognizeManager.h
//  OlderFaceTest
//
//  Created by 公平 on 2019/7/25.
//  Copyright © 2019 ppy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "model.h"
@class UIImage;

NS_ASSUME_NONNULL_BEGIN
typedef void (^CompleateBlock)(NSString *text);



typedef void (^checkArea)(model  *m);

@interface CardRecognizeManager : NSObject


@property (nonatomic,copy) checkArea checkChange;

    
    /**
     *  初始化一个单例
     *
     *  @return 返回一个RecogizeCardManager的实例对象
     */
+ (instancetype)recognizeCardManager;
    
    /**
     *  根据身份证照片得到身份证号码
     *
     *  @param cardImage 传入的身份证照片
     *  @param compleate 识别完成后的回调
     */

- (void)recognizeCardWithImage:(UIImage *)cardImage type:(NSString *)type compleate:(CompleateBlock)compleate;
    
- (void)tesseractRecognizeImage:(UIImage *)image compleate:(CompleateBlock)compleate;


//分解成灰度
- (UIImage *)resolveHuiduWithImage:(UIImage *)image;

//分解二值化
- (UIImage *)resolveErzhihuaWithImage:(UIImage *)image;

//分解腐蚀
- (UIImage *)resolveFushiWithImage:(UIImage *)image;

-(NSMutableArray *) profile:(UIImage *)image;










-(void)start:(UIImage *)image;


// 图片进行灰度处理
-(UIImage *)handleImageBinary:(UIImage * )image fixed:(int)fixed;




#pragma mark - 降噪test


-(UIImage *)ImageTobilateraFilter:(UIImage *)image;


@end

NS_ASSUME_NONNULL_END
