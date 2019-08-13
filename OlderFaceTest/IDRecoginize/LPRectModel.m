//
//  LPRectModel.m
//  OlderFaceTest
//
//  Created by pill on 2019/8/10.
//  Copyright © 2019 ppy. All rights reserved.
//

#import "LPRectModel.h"

@implementation LPRectModel


-(id)initRect:(CGRect)rect  {
    self = [super init];
    if (self) {
        self.rect =rect;
    }
    return self;
}

-(CGRect)proportion:(float)proportion {
    return CGRectMake(_rect.origin.x * proportion, _rect.origin.y * proportion, _rect.size.width * proportion, _rect.size.height * proportion);
}
@end
