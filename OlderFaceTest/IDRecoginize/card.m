//
//  card.m
//  OlderFaceTest
//
//  Created by pill on 2019/8/5.
//  Copyright © 2019 ppy. All rights reserved.
//

#import "card.h"

@implementation card
//nameArray = [NSMutableArray array];
//yearArray = [NSMutableArray array];
//yueriArray = [NSMutableArray array];
//cardArray = [NSMutableArray array];
-(void)handleData:(NSMutableArray *)nameArray yearArray:(NSMutableArray *)yearArray yueriArray:(NSMutableArray *)yueriArray cardArray:(NSMutableArray *)cardArray {
    model * tempModel;
    for (int i = 0; i< nameArray.count; i++) {
        model * item= nameArray[i];
        if (tempModel == nil) {
            tempModel = item;
        }
        if (tempModel.rect.origin.y > item.rect.origin.y) {
            tempModel = item;
        }
    }
    NSMutableArray * tempYueriArray = [self paixun:yueriArray];
    
    
    //让s日期在一条线上
    
    for (int i = 0; i< yearArray.count; i++) {
        model * temp = yearArray[i];
        if (temp.info.intValue > 1000 &&temp.info.intValue < 3000 ) {
            _year = yearArray[i];
        }
    }
    NSMutableArray * tempYueriArray2 = [NSMutableArray array];
    for (int i = 0; i< tempYueriArray.count; i++) {
        model * m = tempYueriArray [i];
        if (_year) {
            if ([self bili:_year.rect.origin.y num2:m.rect.origin.y ]&&m.info.floatValue < 31) {
                [tempYueriArray2 addObject:m];
            }
        }
    }
    BOOL isYueAlready = false;
    for (int i = 0; i< tempYueriArray2.count; i++) {
        model * m = tempYueriArray [i];
        if (m.info.floatValue < 12&&!isYueAlready) {
            _yue = m;
            isYueAlready = true;
        }else if (m.info.floatValue < 31&&isYueAlready) {
            _ri = m;
        }
    }
}
-(NSMutableArray *)paixun:(NSArray *)array {
    NSMutableArray * tempArr = [NSMutableArray arrayWithArray:array];
    for (int i = 0; i < tempArr.count - 1; i++) {
        //比较的躺数
        for (int j = 0; j < tempArr.count - 1 - i; j++) {
            //比较的次数
            model* m1 = tempArr[j];
            model* m2 = tempArr[j+1];
                
            if (m1.rect.origin.x > m2.rect.origin.x ) {
                //这里为升序排序
                model * temp = tempArr[j] ;
                [tempArr replaceObjectAtIndex:j withObject:tempArr[j + 1]];
                //OC中的数组只能存储对象，所以这里转换成string对象
                 [tempArr replaceObjectAtIndex:j + 1 withObject:temp];
            }
        }
    }
    return tempArr;

    
}
-(BOOL) bili:(int)num1 num2:(int) num2 {
    NSString *S1 = [NSString stringWithFormat:@"%d",num1];
    NSString *S2 = [NSString stringWithFormat:@"%d",num2];
    float n =  S1.floatValue/S2.floatValue;
    if (n < 1.2&n > 0.8) {
        return YES;
    }
    return NO;
}
+(BOOL)iscard:(NSString *)message {
    NSString *regex = @"(\\d{6})(\\d{4})(\\d{2})(\\d{2})(\\d{3})([0-9]|X)";
    // 创建谓词对象并设定条件表达式
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    // 字符串判断，然后BOOL值
    BOOL result = [predicate evaluateWithObject:message];
    return result;
}
+(BOOL)isName:(NSString *)message {
    NSString *regex = @"^[\u4e00-\u9fa5]{1,}$";
    // 创建谓词对象并设定条件表达式
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    // 字符串判断，然后BOOL值
    BOOL result = [predicate evaluateWithObject:message];
    return result;
}
+(BOOL)isEthnic:(NSString *)message {
    NSString *regex = @"^[\u4e00-\u9fa5]{1,}$";
    // 创建谓词对象并设定条件表达式
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    // 字符串判断，然后BOOL值
    BOOL result = [predicate evaluateWithObject:message];
    return result;
}
+(BOOL)isAdress:(NSString *)message {
    NSString *regex = @"^([\u4e00-\u9fa5]|\d){6,}$";
    // 创建谓词对象并设定条件表达式
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    // 字符串判断，然后BOOL值
    BOOL result = [predicate evaluateWithObject:message];
    return result;
}
+(BOOL)isYear:(NSString *)message {
    NSString *regex = @"^\\d{4}$";
    // 创建谓词对象并设定条件表达式
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    // 字符串判断，然后BOOL值
    BOOL result = [predicate evaluateWithObject:message];
    return result;
}
+(BOOL)isYueri:(NSString *)message {
    NSString *regex = @"^\\d{1,2}$";
    // 创建谓词对象并设定条件表达式
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    // 字符串判断，然后BOOL值
    BOOL result = [predicate evaluateWithObject:message];
    return result;
}


-(BOOL) isOK {
    if (_name&&_year&&_yue&&_ri&&_address&&_card) {
        return YES;
    }
    return NO;
}
@end
