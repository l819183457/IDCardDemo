//
//  CardRecognizeManager.m
//  OlderFaceTest
//
//  Created by 公平 on 2019/7/25.
//  Copyright © 2019 ppy. All rights reserved.
//

#import "CardRecognizeManager.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>
#import <TesseractOCR/TesseractOCR.h>
#import "card.h"
#import "LPRectModel.h"


@interface CardRecognizeManager ()
{
    NSMutableArray * nameEthnicArray;
    NSMutableArray * ethnicArray; //民族
    NSMutableArray * yearArray;
    NSMutableArray * yueriArray;
    NSMutableArray * cardArray;
    NSMutableArray * addressArray;
}

@end

@implementation CardRecognizeManager
    
+ (instancetype)recognizeCardManager {
    static CardRecognizeManager *recognizeCardManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        recognizeCardManager = [[CardRecognizeManager alloc] init];
    });
    return recognizeCardManager;
}



- (void)recognizeCardWithImage:(UIImage *)cardImage type:(NSString *)type compleate:(CompleateBlock)compleate {
    if ([type isEqualToString:@"result"]) {
        //扫描身份证图片，并进行预处理，定位号码区域图片并返回
        UIImage *numberImage = [self opencvScanCard:cardImage];
        if (numberImage == nil) {
            compleate(nil);
        }
        //利用TesseractOCR识别文字
        [self tesseractRecognizeImage:numberImage compleate:^(NSString *numbaerText) {
            compleate(numbaerText);
        }];
    }else{
        
        
    }
}

//分解成灰度
- (UIImage *)resolveHuiduWithImage:(UIImage *)image{
    
    //将UIImage转换成Mat
    cv::Mat resultImage;
    UIImageToMat(image, resultImage);
    //转为灰度图
    cvtColor(resultImage, resultImage, cv::COLOR_BGR2GRAY);
    
    UIImage *huiduImg = MatToUIImage(resultImage);
    
    return huiduImg;
    
}

//分解二值化
- (UIImage *)resolveErzhihuaWithImage:(UIImage *)image{
    cv::Mat resultImage;
    UIImageToMat(image, resultImage);

    //利用阈值二值化
    cv::threshold(resultImage, resultImage, 100, 255, CV_THRESH_BINARY);
    
    UIImage *erzhihuaImg = MatToUIImage(resultImage);
    return erzhihuaImg;
    
}

//分解腐蚀
- (UIImage *)resolveFushiWithImage:(UIImage *)image{
    
    //将UIImage转换成Mat
    cv::Mat resultImage;
    UIImageToMat(image, resultImage);
    //腐蚀，填充（腐蚀是让黑色点变大）
    cv::Mat erodeElement = getStructuringElement(cv::MORPH_RECT, cv::Size(26,26));
    cv::erode(resultImage, resultImage, erodeElement);
    
    UIImage *fushiIMG = MatToUIImage(resultImage);
    return fushiIMG;
    
}

-(NSMutableArray *) profile:(UIImage *)image {
    NSMutableArray * resultArray = [NSMutableArray array];
    cv::Mat resultImage;
    UIImageToMat(image, resultImage);
    std::vector<std::vector<cv::Point>> contours;//定义一个容器来存储所有检测到的轮廊
    cv::findContours(resultImage, contours, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, cvPoint(0, 0));
    //取出身份证号码区域
    std::vector<cv::Rect> rects;
    cv::Rect numberRect = cv::Rect(0,0,0,0);
    std::vector<std::vector<cv::Point>>::const_iterator itContours = contours.begin();
    for ( ; itContours != contours.end(); ++itContours) {
        cv::Rect rect = cv::boundingRect(*itContours);
        rects.push_back(rect);
        //算法原理
        float scale = 1;//[UIScreen mainScreen].scale;
        [resultArray addObject:[[LPRectModel alloc]initRect:CGRectMake(rect.x/scale, rect.y/scale, rect.width/scale, rect.height/scale)]];
    }
    return resultArray;
}
    //扫描身份证图片，并进行预处理，定位号码区域图片并返回
- (UIImage *)opencvScanCard:(UIImage *)image {
    
    //将UIImage转换成Mat
    cv::Mat resultImage;
    UIImageToMat(image, resultImage);
    //转为灰度图
    cvtColor(resultImage, resultImage, cv::COLOR_BGR2GRAY);
    
    UIImage *huiduImg = MatToUIImage(resultImage);

    //利用阈值二值化
    cv::threshold(resultImage, resultImage, 100, 255, CV_THRESH_BINARY);
    
    UIImage *erzhihuaImg = MatToUIImage(resultImage);

    //腐蚀，填充（腐蚀是让黑色点变大）
    cv::Mat erodeElement = getStructuringElement(cv::MORPH_RECT, cv::Size(26,26));
    cv::erode(resultImage, resultImage, erodeElement);
    
    UIImage *fushiIMG = MatToUIImage(resultImage);

    //轮廊检测
    std::vector<std::vector<cv::Point>> contours;//定义一个容器来存储所有检测到的轮廊
    cv::findContours(resultImage, contours, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, cvPoint(0, 0));
    //取出身份证号码区域
    std::vector<cv::Rect> rects;
    cv::Rect numberRect = cv::Rect(0,0,0,0);
    std::vector<std::vector<cv::Point>>::const_iterator itContours = contours.begin();
    for ( ; itContours != contours.end(); ++itContours) {
        cv::Rect rect = cv::boundingRect(*itContours);
        rects.push_back(rect);
        //算法原理
        if (rect.width > numberRect.width && rect.width > rect.height * 5) {
            numberRect = rect;
        }
    }
    //身份证号码定位失败
    if (numberRect.width == 0 || numberRect.height == 0) {
        return nil;
    }
    //定位成功成功，去原图截取身份证号码区域，并转换成灰度图、进行二值化处理
    cv::Mat matImage;
    UIImageToMat(image, matImage);
    resultImage = matImage(numberRect);
    cvtColor(resultImage, resultImage, cv::COLOR_BGR2GRAY);
    cv::threshold(resultImage, resultImage, 80, 255, CV_THRESH_BINARY);
    //将Mat转换成UIImage
    UIImage *numberImage = MatToUIImage(resultImage);
    return numberImage;
}
    
    //利用TesseractOCR识别文字
- (void)tesseractRecognizeImage:(UIImage *)image compleate:(CompleateBlock)compleate {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
        G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng+chi_sim"];
        tesseract.image = [image g8_blackAndWhite];
//        tesseract.image = image;
        // Start the recognition
        [tesseract recognize];
        //执行回调
        compleate(tesseract.recognizedText);
    });
}
- (void)asynTesseractRecognizeImage:(UIImage *)image compleate:(CompleateBlock)compleate {
    
    G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng+chi_sim"];
//    [tesseract setLanguage:@"chi_sim+eng+chi_sim1"];
    tesseract.image = [image g8_blackAndWhite];
//    tesseract.image = image;
    // Start the recognition
    [tesseract recognize];
    //执行回调
    compleate(tesseract.recognizedText);

}
-(void)initData {
    nameEthnicArray = [NSMutableArray array];
    yearArray = [NSMutableArray array];
    yueriArray = [NSMutableArray array];
    cardArray = [NSMutableArray array];
    nameEthnicArray = [NSMutableArray array];
}

-(void)handleData:(UIImage *)image numberRect:(cv::Rect)numberRect fixed:(int) fixed content:(NSString *)content{
    model * m = [[model alloc]init];
    m.image = image;
    m.rect = CGRectMake(numberRect.x, numberRect.y, numberRect.width, numberRect.height);
    m.fixed = fixed;
    m.info = content;
    if ([card isName:content]) {
        [nameEthnicArray addObject:content];
    }
    if([card isYueri:content]) {
        [yueriArray addObject:m];
    }
    if([card isYear:content]) {
        [yearArray addObject:m];
    }
    if ([card iscard:content]) {
        [cardArray addObject:m];
    }
    if ([card isAdress:content]) {
        [addressArray addObject:m];
    }
}


-(void)start:(UIImage *)image {
    [self initData];
    [self handleImage:image fixed:50];
}


-(void)handleImage:(UIImage * )image fixed:(int)fixed {
    [self opencvScanCard:image fixed:fixed];
    if (fixed >140) {
        return;
    }
    [self handleImage: image fixed:fixed+5];
    
    
    [self filter];
}
-(void) filter {
    
}
//
- (void )opencvScanCard:(UIImage *)image  fixed:(int)fixed  {
    
    //将UIImage转换成Mat
    cv::Mat resultImage;
    UIImageToMat(image, resultImage);
    //转为灰度图
    cvtColor(resultImage, resultImage, cv::COLOR_BGR2GRAY);
    
//    UIImage *huiduImg = MatToUIImage(resultImage);
    //利用阈值二值化
    cv::threshold(resultImage, resultImage, 100, 255, CV_THRESH_BINARY);
    
//    UIImage *erzhihuaImg = MatToUIImage(resultImage);
    
    //腐蚀，填充（腐蚀是让黑色点变大）
    cv::Mat erodeElement = getStructuringElement(cv::MORPH_RECT, cv::Size(26,26));
    cv::erode(resultImage, resultImage, erodeElement);
    
//    UIImage *fushiIMG = MatToUIImage(resultImage);
    
    //轮廊检测
    std::vector<std::vector<cv::Point>> contours;//定义一个容器来存储所有检测到的轮廊
    cv::findContours(resultImage, contours, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, cvPoint(0, 0));
    //取出身份证号码区域
    std::vector<cv::Rect> rects;
//    cv::Rect numberRect = cv::Rect(0,0,0,0);
    std::vector<std::vector<cv::Point>>::const_iterator itContours = contours.begin();
    for ( ; itContours != contours.end(); ++itContours) {
        cv::Rect rect = cv::boundingRect(*itContours);
        rects.push_back(rect);
        [self showVector:image numberRect:rect fixed:fixed];
    }
}
-(void)showVector:(UIImage *)image numberRect:(cv::Rect)numberRect fixed:(int) fixed {
    if (numberRect.width <30||numberRect.height < 30) {
        return;
    }
    cv::Mat resultImage;
    cv::Mat matImage;
    UIImageToMat(image, matImage);
    resultImage = matImage(numberRect);
    cvtColor(resultImage, resultImage, cv::COLOR_BGR2GRAY);
    cv::threshold(resultImage, resultImage, 100, 255, CV_THRESH_BINARY);
    //将Mat转换成UIImage
    UIImage *numberImage = MatToUIImage(resultImage);
    //利用TesseractOCR识别文字
    
    [self asynTesseractRecognizeImage:numberImage compleate:^(NSString *numbaerText) {
        numbaerText = [numbaerText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSLog(@"neirong:%@  - fixed:%d   ",numbaerText,fixed);
//        NSLog(@"-----  X:%d - Y:%d - width:%d - height:%d \n",numberRect.x,numberRect.y,numberRect.width,numberRect.height);
        [self handleData:image numberRect:numberRect fixed:(int)fixed content:numbaerText];
    }];
    
}




#pragma mark - 图片识别
-(UIImage *)handleImageBinary:(UIImage * )image  fixed:(int)fixed {
    cv::Mat resultImage;
    UIImageToMat(image, resultImage);
    //转为灰度图
    cvtColor(resultImage, resultImage, cv::COLOR_BGR2GRAY);
    //利用阈值二值化
    cv::threshold(resultImage, resultImage, fixed, 255, CV_THRESH_BINARY);
    return MatToUIImage(resultImage);
    
}




#pragma mark - 降噪test


-(UIImage *)ImageTobilateraFilter:(UIImage *)image
{
    cv::Mat resultImage;
    cv::Mat gray;
    UIImageToMat(image, resultImage);
    //    cv::cvtColor(mat_image_src, gray,CV_BGR2BGRA);
    cvtColor(resultImage, gray, CV_RGBA2RGB, 7);
    
    cv::Mat mat_image_out;
    bilateralFilter(gray, mat_image_out, 25, 25*2, 35);
    return MatToUIImage(mat_image_out);
    
}

@end
