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
static const CGFloat XTSecurityLength = 75.0;

#define SELF_WIDTH CGRectGetWidth(self.frame)
#define SELF_HEIGHT CGRectGetHeight(self.frame)
#define IMAGE_VIEW_WIDTH CGRectGetWidth(self.frame) - XTButtonSlide
#define IMAGE_VIEW_HEIGHT CGRectGetHeight(self.frame) - XTButtonSlide

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
        self.imagePaster = image;
        
        bgRect = bgView.frame;
        
        [self setupWithBGFrame:bgRect];
        
        self.originSize = recentFrame.size;
        CGRect newFrame = CGRectMake(CGRectGetMinX(recentFrame) - XTButtonSlide / 2, CGRectGetMinY(recentFrame) - XTButtonSlide / 2, CGRectGetWidth(recentFrame) + XTButtonSlide, CGRectGetWidth(recentFrame) + XTButtonSlide);
        
        self.frame = newFrame;
        
        [self btDelete];
        [self btSizeCtrl];
        [bgView addSubview:self];
        self.isOnFirst = YES;
    }
    return self;
}

- (void)setupWithBGFrame:(CGRect)bgFrame {
    
    self.center = CGPointMake(bgFrame.size.width / 2, bgFrame.size.height / 2);
    self.backgroundColor = nil;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapGesture];

    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateGesture:)];
    [self addGestureRecognizer:rotateGesture];
    
    self.userInteractionEnabled = YES;
    
    minWidth = self.bounds.size.width * 0.5;
    minHeight = self.bounds.size.height * 0.5;
  
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
            
            if (finalWidth > self.originSize.width * (1 + 0.5)) {
                finalWidth = self.originSize.width * (1 + 0.5);
            }
            if (finalWidth < self.originSize.width * (1 - 0.5)) {
                finalWidth = self.originSize.width * (1 - 0.5);
            }
            if (finalHeight > self.originSize.height * (1 + 0.5)) {
                finalHeight = self.originSize.height * (1 + 0.5);
            }
            if (finalHeight < self.originSize.height * (1 - 0.5)) {
                finalHeight = self.originSize.height * (1 - 0.5);
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
    
    if (newCenter.x > self.superview.bounds.size.width - midPointX + XTSecurityLength) {
        newCenter.x = self.superview.bounds.size.width - midPointX + XTSecurityLength;
    }
    if (newCenter.x < midPointX - XTSecurityLength) {
        newCenter.x = midPointX - XTSecurityLength;
    }
    
    CGFloat midPointY = CGRectGetMidY(self.bounds);
    
    if (newCenter.y > self.superview.bounds.size.height - midPointY + XTSecurityLength) {
        newCenter.y = self.superview.bounds.size.height - midPointY + XTSecurityLength;
    }
    if (newCenter.y < midPointY - XTSecurityLength) {
        newCenter.y = midPointY - XTSecurityLength;
    }
    
    // Ensure the translation won't cause the view to move offscreen. END
    self.center = newCenter;
}

#pragma mark - Setter

- (void)setFrame:(CGRect)newFrame {
    
    [super setFrame:newFrame];
    
    self.imgContentView.frame = CGRectMake(XTFlexSilde, XTFlexSilde, IMAGE_VIEW_WIDTH, IMAGE_VIEW_HEIGHT);
    
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
        
        _imgContentView = [[UIImageView alloc] initWithFrame:CGRectMake(XTFlexSilde, XTFlexSilde, IMAGE_VIEW_WIDTH, IMAGE_VIEW_HEIGHT)];
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