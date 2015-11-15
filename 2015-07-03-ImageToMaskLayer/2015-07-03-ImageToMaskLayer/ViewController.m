//
//  ViewController.m
//  2015-07-03-ImageToMaskLayer
//
//  Created by TangJR on 7/3/15.
//  Copyright (c) 2015 tangjr. All rights reserved.
//

#import "ViewController.h"
#import "TDrawView.h"
#import "TBigHeadView.h"

#define SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)

@interface ViewController ()

@property (weak, nonatomic) IBOutlet TBigHeadView *bigHeadView;

- (IBAction)sliderValueChanged:(UISlider *)sender;
- (IBAction)finishButotnTapped:(UIButton *)sender;
- (IBAction)clearButtonTapped:(UIButton *)sender;
- (IBAction)resetButtonTapped:(UIButton *)sender;
- (IBAction)startButtonTapped:(UIButton *)sender;
- (IBAction)composeButtonTapped:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.bigHeadView.backgroundImage = [UIImage imageNamed:@"宁泽涛.jpg"];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    
    self.bigHeadView.lineWidth = 20 * sender.value + 10;
}

- (IBAction)finishButotnTapped:(UIButton *)sender {
    
    [self.bigHeadView endDrawing];
}

- (IBAction)clearButtonTapped:(UIButton *)sender {
    
    [self.bigHeadView clearDrawing];
}

- (IBAction)resetButtonTapped:(UIButton *)sender {
    
    
}

- (IBAction)startButtonTapped:(UIButton *)sender {
    
    [self.bigHeadView startDrawing];
}

- (IBAction)composeButtonTapped:(UIButton *)sender {
}

@end