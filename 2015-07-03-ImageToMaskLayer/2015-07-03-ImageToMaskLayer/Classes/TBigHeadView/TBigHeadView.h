//
//  TOriginView.h
//  2015-07-03-ImageToMaskLayer
//
//  Created by TangJR on 7/3/15.
//  Copyright (c) 2015 tangjr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TSuccessBlock)(UIImage *bigHeadImage, UIImage *composeImage);
typedef void(^TFailBlock)(UIImage *bigHeadImage, NSError *error);

@interface TBigHeadView : UIView

@property (assign, nonatomic) CGFloat lineWidth;

@property (strong, nonatomic) UIImage *backgroundImage;

- (void)startDrawing;
- (void)endDrawing;
- (void)continueDrawing;
- (void)clearDrawing;
- (void)composeImageWithSuccess:(TSuccessBlock)success fail:(TFailBlock)fail;

@end