//
//  UIView+EHKFrame.m
//  EHKWePay
//
//  Created by pill on 2018/6/11.
//  Copyright © 2018年 EHK. All rights reserved.
//

#import "UIView+EHKFrame.h"

@implementation UIView (EHKFrame)



-(void)setMj_right_x:(CGFloat)mj_right_x
{
    CGRect frame = self.frame;
    frame.origin.x = mj_right_x - self.frame.size.width;
    self.frame = frame;
}
-(CGFloat)mj_right_x
{
    return self.frame.size.width + self.frame.origin.x;
}
-(void)setMj_right_y:(CGFloat)mj_right_y
{
    CGRect frame = self.frame;
    frame.origin.y = mj_right_y - self.frame.size.height;;;;
    self.frame = frame;
}
-(CGFloat)mj_right_y
{
    return self.frame.size.height + self.frame.origin.y;
}

@end
