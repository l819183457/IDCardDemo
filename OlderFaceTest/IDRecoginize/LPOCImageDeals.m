//
//  LPOCImageDeals.m
//  OlderFaceTest
//
//  Created by pill on 2019/8/11.
//  Copyright © 2019 ppy. All rights reserved.
//

#import "LPOCImageDeals.h"

@implementation LPOCImageDeals


//// 矩形透视矫正
//- (void)perspectiveCorrection
//{
//    NSLog(@"%@---%@",NSStringFromCGRect(_img.extent),NSStringFromCGRect(_feature.bounds));
//    //1. 剪切矩形
//    _img = [_img imageByCroppingToRect:_feature.bounds];
//    [self addImg];  // 添加剪切后的矩形
//
//    //2. 透视矫正
//    NSDictionary *para = @{
//                           @"inputTopLeft": [CIVector vectorWithCGPoint:_feature.topLeft],
//                           @"inputTopRight": [CIVector vectorWithCGPoint:_feature.topRight],
//                           @"inputBottomLeft": [CIVector vectorWithCGPoint:_feature.bottomLeft],
//                           @"inputBottomRight": [CIVector vectorWithCGPoint:_feature.bottomRight]
//                           };
//    _img = [_img imageByApplyingFilter:@"CIPerspectiveCorrection" withInputParameters:para];
//    [self addImg];
//}

//灰度图 : 主要用来做文字识别所以直接去掉色彩信息
//- (void)huidu
//{
//    CIColor *filterInputcolor = [CIColor colorWithRed:0.75 green:0.75 blue:0.75];
//    //只有在主动设置的时候才丢弃颜色信息
//    //CIColorMonochrome  单色滤镜
//    CIImage * img =  [CIImage imageWithCGImage:_image.CGImage];
//    img = [img imageByApplyingFilter:@"CIColorMonochrome" withInputParameters:@{kCIInputColorKey : filterInputcolor}];
//    return [UIImage imageWithCGImage:img];
//}
//
////提升亮度 --> 会损失一部分背景纹理 饱和度不能太高
//- (void)liangdu
//{
//    NSDictionary *para = @{
//                           kCIInputSaturationKey : @(0.35),  //饱和度
//                           kCIInputBrightnessKey : @(0.2),  //亮度
//                           kCIInputContrastKey : @(1.1)     //对比度
//                           };
//
//    //CIColorControls 调整饱和度、亮度和对比度值
//    _img = [_img imageByApplyingFilter:@"CIColorControls" withInputParameters:para];
//
//    [self addImg];
//}
//
//// 曝光调节  CIExposureAdjust
//- (void)baoguang
//{
//    _img = [_img imageByApplyingFilter:@"CIExposureAdjust" withInputParameters:@{kCIInputEVKey : @(0.65)}];
//
//    [self addImg];
//}
//
////高斯模糊
//- (void)gaosimohu
//{
//    _img = [_img imageByApplyingGaussianBlurWithSigma:0.4];
//    [self addImg];
//}
//
//- (void)zengqianglunkuo
//{
//    //6. 增强文字轮廓
//    NSDictionary* para = @{
//                           kCIInputRadiusKey : @(2.5),                //获取或设置要检测的最小要素的半径。
//                           kCIInputIntensityKey : @(0.5),             //获取或设置增强对比度的强度
//                           };
//
//    _img = [_img imageByApplyingFilter:@"CIUnsharpMask" withInputParameters:para];
//
//    [self addImg];
//}
//
////- (void)heibai
////{
////    _img = [_img imageByApplyingFilter:@"CIEdgeWork" withInputParameters:@{kCIInputRadiusKey : @(2.5)}];
////    [self addImg];
////}
//
//// 调低亮度,增高对比度 (图片字体更黑)
//- (void)baoguang1
//{
//    NSDictionary *para = @{
//                           kCIInputSaturationKey : @(0.35),  //饱和度
//                           kCIInputBrightnessKey : @(-0.7),  //亮度
//                           kCIInputContrastKey : @(1.9)     //对比度
//                           };
//
//    //CIColorControls 调整饱和度、亮度和对比度值
//    _img = [_img imageByApplyingFilter:@"CIColorControls" withInputParameters:para];
//
//    [self addImg];
//}
//
//// 增加曝光,使上一步调黑的背景变白
//- (void)baoguang2
//{
//    _img = [_img imageByApplyingFilter:@"CIExposureAdjust" withInputParameters:@{kCIInputEVKey : @(0.65)}];
//
//    [self addImg];
//}

@end
