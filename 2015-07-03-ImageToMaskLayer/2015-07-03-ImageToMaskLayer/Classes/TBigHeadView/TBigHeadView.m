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

static const NSInteger TPasterId = 1;

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
        
        [self setupUI];
    }
    
    return self;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        [self setupUI];
    }
    
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    
    // 如果imageView与hiddenImageView已经有值了，就不再重复走这个方法（一般都没有，防止重复走）
    if (self.imageView && self.hiddenImageView) {
        return;
    }
    
    self.clipsToBounds = YES;
    [self setupImageView];
}

- (void)setupImageView {
    
    UIImageView *imageView = [self generalImageView];
    imageView.userInteractionEnabled = YES;
    self.imageView = imageView;
    
    UIImageView *hiddenImageView = [self generalImageView];
    self.hiddenImageView = hiddenImageView;
}

- (void)setupTouchView {
    
    TDrawView *touchView = [TDrawView new];
    touchView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:touchView];
    self.touchView = touchView;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:touchView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:touchView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:touchView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:touchView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

- (UIImageView *)generalImageView {
    
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:imageView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    return imageView;
}

#pragma mark - Public methods

- (void)startDrawing {
    
    [self setupTouchView];
}

- (void)endDrawing {
    
    UIImage *maskImage = [self.touchView st_screenShot];
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.contents = (__bridge id)maskImage.CGImage;
    self.hiddenImageView.layer.mask = maskLayer;
    UIImage *image2 = [self.hiddenImageView st_screenShot];
    UIImage *image3 = [image2 st_clipWithRect:self.touchView.imageRect];
    
    [self pinToScreenWithImage:image3 recentFrame:self.touchView.imageRect];
    self.touchView.hidden = YES;
    self.hiddenImageView.hidden = YES;
}

- (void)continueDrawing {
    
    self.touchView.isClear = NO;
}

- (void)clearDrawing {
    
    self.touchView.isClear = YES;
}

- (void)composeImageWithSuccess:(TSuccessBlock)success fail:(TFailBlock)fail {
    
    
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.pasterView.isOnFirst = NO;
}

#pragma mark - XTPasterViewDelegate

- (void)makePasterBecomeFirstRespond:(NSInteger)pasterID {
    
    
}

- (void)removePaster:(NSInteger)pasterID {
    
    
}

#pragma mark - Private methods

- (void)pinToScreenWithImage:(UIImage *)image recentFrame:(CGRect)recentFrame {
    
    XTPasterView *pasterView = [[XTPasterView alloc] initWithBgView:self.imageView pasterID:TPasterId image:image recentFrame:recentFrame];
    pasterView.backgroundColor = [UIColor clearColor];
    pasterView.delegate = self;
    self.pasterView = pasterView;
}

#pragma mark - Property getter/setter

- (void)setLineWidth:(CGFloat)lineWidth {
    
    _lineWidth = lineWidth;
    self.touchView.lineWidth = lineWidth;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    
    _backgroundImage = backgroundImage;
    self.imageView.image = backgroundImage;
    self.hiddenImageView.image = backgroundImage;
}

@end