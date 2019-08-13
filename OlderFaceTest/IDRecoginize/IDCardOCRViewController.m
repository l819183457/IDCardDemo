//
//  IDCardOCRViewController.m
//  OlderFaceTest
//
//  Created by pill on 2019/8/7.
//  Copyright © 2019 ppy. All rights reserved.
//






#import "IDCardOCRViewController.h"
#import "CardRecognizeManager.h"
#import "model.h"
#import "UIView+EHKFrame.h"
#import "UIView+MJExtension.h"
#import "LPRectModel.h"
@interface IDCardOCRViewController ()<UITableViewDelegate,UITableViewDataSource> {
    UITableView *  imageTable ;
    CardRecognizeManager * manage;
    UIView * layerView;
}

@end

@implementation IDCardOCRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _image = [UIImage imageNamed:@"card"];
    _imageView.image =  _image;
     manage = [CardRecognizeManager recognizeCardManager];
    
    
    
    // SLIDER ACTION
    [self.slider addTarget:self action:@selector(sliderProgressChange:) forControlEvents:UIControlEventValueChanged];
    [self.slider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.slider addTarget:self action:@selector(sliderTouchUpInSide:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    CardRecognizeManager * manage = [CardRecognizeManager recognizeCardManager];
//    [manage start:_image];
//    manage.checkChange = ^(model * m) {
////        _partImageView.image = m.image;
//
//    };
}
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    CGSize size = CGSizeMake(self.view.mj_w, 100);//_image.size;
    CGSize size =_image.size;
    float W = self.view.frame.size.width > size.width ? size.width: self.view.frame.size.width;
    float H = size.height * W / size.width;
    _imageView.frame = CGRectMake((self.view.frame.size.width - W)/2., 50, W, H);
    _thresholdLabel.frame = CGRectMake(self.view.mj_w - 10 - 60, _imageView.mj_right_y+30, 60, 30);
    _slider.frame= CGRectMake(10, _imageView.mj_right_y+30, _thresholdLabel.mj_x - 10, 30);
    
    
    _partImageView.frame = CGRectMake(10, _imageView.frame.size.height + _imageView.frame.origin.y+10, 100, 50);
    
    
    float btnW  =( self.view.mj_w - 20  - 20 * 4)/5.;
    float btnH = 30;
    _grayBtn.frame =   CGRectMake(10, _slider.mj_right_y + 20, btnW, btnH);
    _corrosionBtn.frame = CGRectMake(_grayBtn.mj_right_x + 20, _slider.mj_right_y + 20, btnW, btnH);
    _profileBtn.frame = CGRectMake(_corrosionBtn.mj_right_x + 20, _slider.mj_right_y + 20, btnW, btnH);
    _ocrBtn.frame = CGRectMake(_profileBtn.mj_right_x + 20, _slider.mj_right_y + 20, btnW, btnH);
    _resetBtn.frame = CGRectMake(_ocrBtn.mj_right_x + 20    , _slider.mj_right_y + 20, btnW, btnH);
    if (layerView) {
        layerView.frame = _imageView.frame;
    }
    
}

#pragma mark - slider
-(void)sliderProgressChange:(UISlider *)slider {
    int threshold = 50;
    threshold = threshold + (int)(slider.value * 150);
    NSLog(@"%d",threshold);
    _thresholdLabel.text = [NSString stringWithFormat:@"%d",threshold];
    _imageView.image = [manage handleImageBinary:_image fixed:threshold];
}
-(void)sliderTouchDown:(UISlider *)slider {
    
}
-(void)sliderTouchUpInSide:(UISlider *)slider {
    
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellin = @"cellindex";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellin];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:cellin];
    }
    return cell;
//
}
-(IBAction)clickGrayBtn:(id)sender {
    [self clearLayer];
    _imageView.image = [manage resolveHuiduWithImage:_image ];
}
- (IBAction)clickCorrosionBtn:(id)sender {
    [self clearLayer];
    _imageView.image = [manage resolveFushiWithImage:[manage handleImageBinary:_image fixed:_thresholdLabel.text.intValue] ];
}
- (IBAction)clikProfileBtn:(id)sender {
    [self clearLayer];
    UIImage * image = [manage resolveFushiWithImage:[manage handleImageBinary:_image fixed:_thresholdLabel.text.intValue] ];
    NSMutableArray * array = [manage profile:image];
    layerView = [[UIView alloc]init];
//    layerView.backgroundColor = UIColor.redColor;
    [self.view addSubview:layerView];
    for ( int i = 0; i <array.count; i++) {
        LPRectModel * rect = array[i];
        UIImageView * img = [[UIImageView alloc]init];
        img.layer.borderWidth = 1;
        img.layer.borderColor = [UIColor redColor].CGColor;
        
        img.frame = [rect proportion:(_imageView.mj_w /_image.size.width)];
        [layerView addSubview:img];
    }
    
}
-(void)clearLayer {
    [layerView removeFromSuperview];
    layerView = nil;
}
- (IBAction)clickResetBtn:(id)sender {
    [self clearLayer];
    _imageView.image = _image;
    _thresholdLabel.text = @"100";
    _slider.value = 0.3;
}
- (IBAction)clickOCRBtn:(id)sender {
    UIImage * image =[manage handleImageBinary:_image fixed:_thresholdLabel.text.intValue] ;
    [manage tesseractRecognizeImage:image compleate:^(NSString * _Nonnull text) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:text preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }] ;
//   UIImage * IMAGE111 =  [manage ImageTobilateraFilter:image];
    
}
@end
