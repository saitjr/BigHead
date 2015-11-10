//
//  UIImage+Blur.m
//  Popping
//
//  Created by André Schneider on 10.07.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import "UIImage+STBasicTools.h"

@implementation UIImage (STBasicTools)

+ (UIImage *)st_imageNoCacheWithName:(NSString *)imageName {
    
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:imageName]];
    
    return image;
}

- (UIImage *)st_blurredImage {
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:10.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return returnImage;
}

- (UIImage *)st_clipWithRect:(CGRect)rect {
    
    CGImageRef sourceImageRef = [self CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}

- (UIImage *)st_scaleWithMaxSize:(CGSize)maxSize {
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    if (width < maxSize.width && height < maxSize.height) {
        
        return self;
    }
    
    CGFloat scale = width / maxSize.width > height / maxSize.height ? width / maxSize.width : height / maxSize.height;
    
    return [self st_scaleWithScale:scale];
}

- (UIImage *)st_scaleWithScale:(CGFloat)scale {
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    CGSize newSize = CGSizeMake(width * scale, height * scale);
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end