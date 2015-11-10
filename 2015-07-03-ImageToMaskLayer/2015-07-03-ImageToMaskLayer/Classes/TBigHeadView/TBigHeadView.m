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

#import "XTPasterStageView.h"

@interface TBigHeadView ()

@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UIImageView *hiddenImageView;

@property (weak, nonatomic) TDrawView *touchView;
@property (weak, nonatomic) XTPasterStageView *stageView;

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
    
    self.touchView.userInteractionEnabled = NO;
    
    UIImage *image = [self.touchView st_screenShot];
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.contents = (__bridge id)image.CGImage;
    self.hiddenImageView.layer.mask = maskLayer;
    UIImage *image2 = [self.hiddenImageView st_screenShot];
    UIImage *image3 = [image2 st_clipWithRect:self.touchView.imageRect];
//    [self saveImage:image3];
    
    [self pinToScreenWithImage:image3 recentFrame:self.touchView.imageRect];
    
}

- (void)pinToScreenWithImage:(UIImage *)image recentFrame:(CGRect)recentFrame {
    
    XTPasterStageView *stageView = [[XTPasterStageView alloc] initWithFrame:recentFrame];
    stageView.originImage = image;
    stageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:stageView];
    
    self.stageView = stageView;
    
    
    [self.stageView addPasterWithImg:image];
}

- (void)saveImage:(UIImage *)image {
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", path, @"1.png"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 如果路径不存在，则创建路径
    if ([fileManager fileExistsAtPath:fullPath] == NO) {
        
        NSError *error = nil;
        
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    [UIImagePNGRepresentation(image) writeToFile:fullPath atomically:YES];
}

- (void)continueDrawing {
    
    self.touchView.isClear = NO;
}

- (void)clearDrawing {
    
    self.touchView.isClear = YES;
}

#pragma mark - Private methods

#pragma mark - Property getter/setter

- (void)setLineWidth:(CGFloat)lineWidth {
    
    _lineWidth = lineWidth;
    self.touchView.lineWidth = lineWidth;
}

@end