//
//  XTPasterView.m
//  XTPasterManager
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "XTPasterView.h"

static const CGFloat XTFlexSilde = 15.0;
static const CGFloat XTButtonSlide = 30.0;
static const CGFloat XTBorderLineWidth = 1.0;
static const CGFloat XTMultiplyingPower = 1; // 缩放倍率。最大放大0.8倍（即：原大小的1.8倍）

#define XT_SECURITY_WIDTH XT_IMAGE_WIDTH / 2
#define XT_IMAGE_WIDTH self.originSize.width
#define XT_IMAGE_HEIGHT self.originSize.height

#define XT_SELF_WIDTH CGRectGetWidth(self.frame)
#define XT_SELF_HEIGHT CGRectGetHeight(self.frame)

@interface XTPasterView () {
    
    CGFloat minWidth;
    CGFloat minHeight;
    CGFloat deltaAngle;
    CGPoint prevPoint;
    CGPoint touchStart;
    CGRect  bgRect;
}

@property (strong, nonatomic) UIImageView *btDelete;
@property (strong, nonatomic) UIImageView *btSizeCtrl;
@property (assign, nonatomic) CGSize originSize;

@end

@implementation XTPasterView

- (void)remove {
    
    [self removeFromSuperview];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(removePaster:)]) {
        [self.delegate removePaster:self.pasterID];
    }
}

#pragma mark - init

- (instancetype)initWithBgView:(UIImageView *)bgView pasterID:(NSInteger)pasterID image:(UIImage *)image recentFrame:(CGRect)recentFrame {
    
    self = [super init];
    
    if (self) {
        
        self.pasterID = pasterID;
        
        bgRect = bgView.frame;
        
        CGRect newFrame = CGRectMake(CGRectGetMinX(recentFrame) + XTFlexSilde, CGRectGetMinY(recentFrame) + XTFlexSilde, CGRectGetWidth(recentFrame) + XTButtonSlide, CGRectGetWidth(recentFrame) + XTButtonSlide);
        self.originSize = newFrame.size;
        
        [self setupWithBGFrame:bgRect];

        self.center = CGPointMake(CGRectGetMidX(recentFrame), CGRectGetMidY(recentFrame));
        self.imagePaster = image;
        
        [bgView addSubview:self];
        self.isOnFirst = YES;
    }
    return self;
}

- (void)setupWithBGFrame:(CGRect)bgFrame {
    
    CGRect rect = CGRectZero;
    rect.size = CGSizeMake(XT_IMAGE_WIDTH + XTButtonSlide, XT_IMAGE_HEIGHT + XTButtonSlide);
    self.frame = rect;
    self.center = CGPointMake(bgFrame.size.width / 2, bgFrame.size.height / 2);
    self.backgroundColor = nil;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapGesture];

    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateGesture:)];
    [self addGestureRecognizer:rotateGesture];
    
    self.userInteractionEnabled = YES;
    
    minWidth = self.bounds.size.width * XTMultiplyingPower;
    minHeight = self.bounds.size.height * XTMultiplyingPower;
  
    deltaAngle = atan2(self.frame.origin.y + self.frame.size.height - self.center.y, self.frame.origin.x + self.frame.size.width - self.center.x);
}

#pragma mark - Gesture

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    
    self.isOnFirst = YES;
    [self makePasterBecomeFirstRespond];
}

- (void)handleRotateGesture:(UIRotationGestureRecognizer *)rotateGesture {
    
    self.isOnFirst = YES;
    [self makePasterBecomeFirstRespond];
    
    self.transform = CGAffineTransformRotate(self.transform, rotateGesture.rotation);
    rotateGesture.rotation = 0;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
        return;
    }
    if ([recognizer state] == UIGestureRecognizerStateChanged) {
        
        if (self.bounds.size.width < minWidth || self.bounds.size.height < minHeight) {
            
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, minWidth + 1, minHeight + 1);
            self.btSizeCtrl.frame = CGRectMake(self.bounds.size.width - XTButtonSlide, self.bounds.size.height - XTButtonSlide, XTButtonSlide, XTButtonSlide);
            prevPoint = [recognizer locationInView:self];
        } else {
            
            CGPoint point = [recognizer locationInView:self];
            float wChange = 0.0, hChange = 0.0;
            
            wChange = (point.x - prevPoint.x);
            float wRatioChange = (wChange / (float)self.bounds.size.width);
            
            hChange = wRatioChange * self.bounds.size.height;
            
            if (ABS(wChange) > 50.0f || ABS(hChange) > 50.0f) {
                prevPoint = [recognizer locationOfTouch:0 inView:self];
                return;
            }
            
            CGFloat finalWidth  = self.bounds.size.width + (wChange);
            CGFloat finalHeight = self.bounds.size.height + (wChange);
            
            if (finalWidth > XT_IMAGE_WIDTH * (1 + XTMultiplyingPower)) {
                finalWidth = XT_IMAGE_WIDTH * (1 + XTMultiplyingPower);
            }
            if (finalWidth < XT_IMAGE_WIDTH * (1 - XTMultiplyingPower)) {
                finalWidth = XT_IMAGE_WIDTH * (1 - XTMultiplyingPower);
            }
            if (finalHeight > XT_IMAGE_HEIGHT * (1 + XTMultiplyingPower)) {
                finalHeight = XT_IMAGE_HEIGHT * (1 + XTMultiplyingPower);
            }
            if (finalHeight < XT_IMAGE_HEIGHT * (1 - XTMultiplyingPower)) {
                finalHeight = XT_IMAGE_HEIGHT * (1 - XTMultiplyingPower);
            }
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, finalWidth, finalHeight);
            self.btSizeCtrl.frame = CGRectMake(self.bounds.size.width - XTButtonSlide, self.bounds.size.height - XTButtonSlide, XTButtonSlide, XTButtonSlide);
            prevPoint = [recognizer locationOfTouch:0 inView:self];
        }
        
        float ang = atan2([recognizer locationInView:self.superview].y - self.center.y, [recognizer locationInView:self.superview].x - self.center.x);
        float angleDiff = deltaAngle - ang;
        self.transform = CGAffineTransformMakeRotation(-angleDiff);
        [self setNeedsDisplay];
        return;
    }
    if ([recognizer state] == UIGestureRecognizerStateEnded) {
        prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
        return;
    }
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.isOnFirst = YES;
    [self makePasterBecomeFirstRespond];

    UITouch *touch = [touches anyObject];
    touchStart = [touch locationInView:self.superview];
}

- (void)makePasterBecomeFirstRespond {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(makePasterBecomeFirstRespond:)]) {
        [self.delegate makePasterBecomeFirstRespond:self.pasterID];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.btSizeCtrl.frame, touchLocation)) {
        return;
    }
    
    CGPoint touch = [[touches anyObject] locationInView:self.superview];
    
    [self translateUsingTouchLocation:touch];
    
    touchStart = touch;
}

- (void)translateUsingTouchLocation:(CGPoint)touchPoint {
    
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - touchStart.x, self.center.y + touchPoint.y - touchStart.y);
    
    // Ensure the translation won't cause the view to move offscreen. BEGIN
    CGFloat midPointX = CGRectGetMidX(self.bounds);
    
    if (newCenter.x > self.superview.bounds.size.width - midPointX + XT_SECURITY_WIDTH) {
        newCenter.x = self.superview.bounds.size.width - midPointX + XT_SECURITY_WIDTH;
    }
    if (newCenter.x < midPointX - XT_SECURITY_WIDTH) {
        newCenter.x = midPointX - XT_SECURITY_WIDTH;
    }
    
    CGFloat midPointY = CGRectGetMidY(self.bounds);
    
    if (newCenter.y > self.superview.bounds.size.height - midPointY + XT_SECURITY_WIDTH) {
        newCenter.y = self.superview.bounds.size.height - midPointY + XT_SECURITY_WIDTH;
    }
    if (newCenter.y < midPointY - XT_SECURITY_WIDTH) {
        newCenter.y = midPointY - XT_SECURITY_WIDTH;
    }
    
    // Ensure the translation won't cause the view to move offscreen. END
    self.center = newCenter;
}

#pragma mark - Setter

- (void)setFrame:(CGRect)newFrame {
    
    [super setFrame:newFrame];
    
    CGRect rect = CGRectZero ;
    CGFloat sliderWidth = XT_IMAGE_WIDTH;
    CGFloat sliderHeight = XT_IMAGE_HEIGHT;
    rect.origin = CGPointMake(XTFlexSilde, XTFlexSilde);
    rect.size = CGSizeMake(sliderWidth, sliderHeight);
    self.imgContentView.frame = rect;
    self.imgContentView.backgroundColor = [UIColor clearColor];
    
    self.imgContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)setImagePaster:(UIImage *)imagePaster {
    
    _imagePaster = imagePaster;
    self.imgContentView.image = imagePaster;
}

- (void)setIsOnFirst:(BOOL)isOnFirst {
    
    _isOnFirst = isOnFirst;
    
    self.btDelete.hidden = !isOnFirst;
    self.btSizeCtrl.hidden = !isOnFirst;
    self.imgContentView.layer.borderWidth = isOnFirst ? XTBorderLineWidth : 0.0f;
}

#pragma mark - 懒加载

- (UIImageView *)imgContentView {
    
    if (!_imgContentView) {
        
        CGRect rect = CGRectZero;
        CGFloat sliderWidth = XT_IMAGE_WIDTH;
        CGFloat sliderHeight = XT_IMAGE_HEIGHT;
        rect.origin = CGPointMake(XTFlexSilde, XTFlexSilde);
        rect.size = CGSizeMake(sliderWidth, sliderHeight);
        
        _imgContentView = [[UIImageView alloc] initWithFrame:rect];
        _imgContentView.backgroundColor = nil;
        _imgContentView.layer.borderColor = [UIColor whiteColor].CGColor;
        _imgContentView.layer.borderWidth = XTBorderLineWidth;
        _imgContentView.contentMode = UIViewContentModeScaleAspectFit;
        
        if (![_imgContentView superview]) {
            
            [self addSubview:_imgContentView];
        }
    }
    return _imgContentView;
}

- (UIImageView *)btSizeCtrl {
    
    if (!_btSizeCtrl) {
        
        _btSizeCtrl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - XTButtonSlide, self.frame.size.height - XTButtonSlide, XTButtonSlide, XTButtonSlide)];
        _btSizeCtrl.userInteractionEnabled = YES;
        _btSizeCtrl.image = [UIImage imageNamed:@"bt_paster_transform"];

        UIPanGestureRecognizer *panResizeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [_btSizeCtrl addGestureRecognizer:panResizeGesture];
        
        if (![_btSizeCtrl superview]) {
            [self addSubview:_btSizeCtrl];
        }
    }
    return _btSizeCtrl;
}

- (UIImageView *)btDelete {
    
    if (!_btDelete) {
        
        CGRect btRect = CGRectZero;
        btRect.size = CGSizeMake(XTButtonSlide, XTButtonSlide);

        _btDelete = [[UIImageView alloc]initWithFrame:btRect];
        _btDelete.userInteractionEnabled = YES;
        _btDelete.image = [UIImage imageNamed:@"bt_paster_delete"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteButtonTapped:)];
        [_btDelete addGestureRecognizer:tap];
        
        if (![_btDelete superview]) {
            [self addSubview:_btDelete];
        }
    }
    return _btDelete;
}

#pragma mark - Button Tapped

- (void)deleteButtonTapped:(UIButton *)sender {
    
    [self remove];
}

@end