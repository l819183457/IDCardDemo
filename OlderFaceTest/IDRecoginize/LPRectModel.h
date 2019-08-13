//
//  LPRectModel.h
//  OlderFaceTest
//
//  Created by pill on 2019/8/10.
//  Copyright © 2019 ppy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface LPRectModel : NSObject

@property  (nonatomic, assign) CGRect rect;
-(id)initRect:(CGRect)rect ;
-(CGRect)proportion:(float)proportion;
@end

NS_ASSUME_NONNULL_END
