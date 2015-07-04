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
#import <TKit.h>

@interface ViewController ()

@property (weak, nonatomic) TDrawView *touchView;
@property (weak, nonatomic) TBigHeadView *originView;

- (IBAction)sliderValueChanged:(UISlider *)sender;
- (IBAction)finishButotnTapped:(UIButton *)sender;
- (IBAction)clearButtonTapped:(UIButton *)sender;
- (IBAction)continueButtonTapped:(UIButton *)sender;
- (IBAction)startButtonTapped:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    TBigHeadView *originView = [[TBigHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 100)];
    [self.view addSubview:originView];
    self.originView = originView;
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    
    self.originView.lineWidth = 20 * sender.value + 10;
}

- (IBAction)finishButotnTapped:(UIButton *)sender {
    
    [self.originView endDrawing];
}

- (IBAction)clearButtonTapped:(UIButton *)sender {
    
    [self.originView clearDrawing];
}

- (IBAction)continueButtonTapped:(UIButton *)sender {
    
    [self.originView continueDrawing];
}

- (IBAction)startButtonTapped:(UIButton *)sender {
    
    [self.originView startDrawing];
}

@end