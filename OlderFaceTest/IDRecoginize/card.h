//
//  card.h
//  OlderFaceTest
//
//  Created by pill on 2019/8/5.
//  Copyright © 2019 ppy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "model.h"
NS_ASSUME_NONNULL_BEGIN

@interface card : NSObject

@property (nonatomic,strong) model * name;//姓名
@property (nonatomic,strong) model * year;//年
@property (nonatomic,strong) model * yue;//年
@property (nonatomic,strong) model * ri;//年
@property (nonatomic,strong) model * address;//年
@property (nonatomic,strong) model * card;//年


-(void)handleData:(NSMutableArray *)nameArray yearArray:(NSMutableArray *)yearArray yueriArray:(NSMutableArray *)yueriArray cardArray:(NSMutableArray *)cardArray;
-(BOOL) isOK;

+(BOOL)iscard:(NSString *)message;
+(BOOL)isName:(NSString *)message;
+(BOOL)isYear:(NSString *)message;
+(BOOL)isYueri:(NSString *)message;
+(BOOL)isAdress:(NSString *)message;
+(BOOL)isEthnic:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
