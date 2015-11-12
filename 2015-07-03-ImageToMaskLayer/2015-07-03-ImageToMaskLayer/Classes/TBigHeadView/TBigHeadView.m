//
//  TOriginView.m
//  2015-07-03-ImageToMaskLayer
//
//  Created by TangJR on 7/3/15.
//  Copyright (c) 2015 tangjr. All rights reserved.
//

#import "TBigHeadView.h"
#import "TDrawView.h"
#import "TResultView.h"
#import "UIImage+STBasicTools.h"
#import "UIView+STBasicTools.h"

#import "XTPasterView.h"

@interface TBigHeadView () <XTPasterViewDelegate>

@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UIImageView *hiddenImageView;

@property (weak, nonatomic) TDrawView *touchView;
@property (weak, nonatomic) XTPasterView *pasterView;

@end

@implementation TBigHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupImageView];
    }
    
    return self;
}

- (void)setupImageView {
    
    UIImageView *imageView = [self generalImageView];
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    self.imageView = imageView;
    
    UIImageView *hiddenImageView = [self generalImageView];
    [self addSubview:hiddenImageView];
    self.hiddenImageView = hiddenImageView;
}

- (void)setupTouchView {
    
    TDrawView *touchView = [[TDrawView alloc] initWithFrame:self.bounds];
    [self addSubview:touchView];
    self.touchView = touchView;
}

- (UIImageView *)generalImageView {
    
    UIImage *image = [UIImage imageNamed:@"宁泽涛.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = self.bounds;
    return imageView;
}

#pragma mark - Public methods

- (void)startDrawing {
    
    [self setupTouchView];
}

- (void)endDrawing {
    
    UIImage *image = [self.touchView st_screenShot];
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.contents = (__bridge id)image.CGImage;
    self.hiddenImageView.layer.mask = maskLayer;
    UIImage *image2 = [self.hiddenImageView st_screenShot];
    UIImage *image3 = [image2 st_clipWithRect:self.touchView.imageRect];
    
    [self pinToScreenWithImage:image3 recentFrame:self.touchView.imageRect];
    self.touchView.hidden = YES;
    self.hiddenImageView.hidden = YES;
}

- (void)pinToScreenWithImage:(UIImage *)image recentFrame:(CGRect)recentFrame {
    
    XTPasterView *pasterView = [[XTPasterView alloc] initWithBgView:self.imageView pasterID:1 image:image];
    pasterView.delegate = self;
    
    self.pasterView = pasterView;
}

- (void)continueDrawing {
    
    self.touchView.isClear = NO;
}

- (void)clearDrawing {
    
    self.touchView.isClear = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.pasterView.isOnFirst = NO;
}

#pragma mark - XTPasterViewDelegate

- (void)makePasterBecomeFirstRespond:(NSInteger)pasterID {
    
    NSLog(@"----%ld", pasterID);
}

- (void)removePaster:(NSInteger)pasterID {
    
    NSLog(@">>>>%ld", pasterID);
}

#pragma mark - Private methods

#pragma mark - Property getter/setter

- (void)setLineWidth:(CGFloat)lineWidth {
    
    _lineWidth = lineWidth;
    self.touchView.lineWidth = lineWidth;
}

@end