//
//  IDCardOCRViewController.h
//  OlderFaceTest
//
//  Created by pill on 2019/8/7.
//  Copyright © 2019 ppy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IDCardOCRViewController : UIViewController

@property (nonatomic,strong) UIImage * image;
@property (nonatomic,strong) IBOutlet UIImageView * imageView;
@property (nonatomic,strong) IBOutlet UIImageView * partImageView;
@property (nonatomic,strong) IBOutlet UISlider * slider;
@property (nonatomic,strong) IBOutlet UILabel * thresholdLabel;

@property (nonatomic,strong) IBOutlet UIButton * grayBtn;
-(IBAction)clickGrayBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *corrosionBtn;

- (IBAction)clickCorrosionBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *profileBtn;

- (IBAction)clikProfileBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *ocrBtn;
- (IBAction)clickOCRBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
- (IBAction)clickResetBtn:(id)sender;

@end

NS_ASSUME_NONNULL_END
