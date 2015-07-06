//
//  TResultView.m
//  2015-07-03-ImageToMaskLayer
//
//  Created by TangJR on 7/5/15.
//  Copyright (c) 2015 tangjr. All rights reserved.
//

#import "TResultView.h"

@interface TResultView ()

@end

@implementation TResultView

- (void)setImage:(UIImage *)image {
    
    _image = image;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if (!self.image) {
        
        return;
    }
    
    CGImageRef image = [self.image CGImage];
    NSUInteger width = CGImageGetWidth(image);
    NSUInteger height = CGImageGetHeight(image);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    free(rawData);
    CGContextRelease(context);
}

@end