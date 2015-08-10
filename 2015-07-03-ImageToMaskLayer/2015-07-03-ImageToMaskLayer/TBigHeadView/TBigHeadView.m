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
#import <TKit.h>

@interface TBigHeadView ()

@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UIImageView *hiddenImageView;

@property (weak, nonatomic) TDrawView *touchView;

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
    
    UIImage *image = [self.touchView screenShot];
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.contents = (__bridge id)image.CGImage;
    self.hiddenImageView.layer.mask = maskLayer;
    UIImage *image2 = [self.hiddenImageView screenShot];
    UIImage *image3 = [image2 clipWithRect:self.touchView.imageRect];
    TSaveFileWithPathAndName(TSandBoxPathWithFinderType(TSandBoxFinderDocument), @"1.png", UIImagePNGRepresentation(image3), TFileImage, YES);
}

- (void)continueDrawing {
    
    self.touchView.isClear = NO;
}

- (void)clearDrawing {
    
    self.touchView.isClear = YES;
}

#pragma mark - Property getter/setter

- (void)setLineWidth:(CGFloat)lineWidth {
    
    _lineWidth = lineWidth;
    self.touchView.lineWidth = lineWidth;
}

@end