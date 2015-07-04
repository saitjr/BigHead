//
//  TOriginView.h
//  2015-07-03-ImageToMaskLayer
//
//  Created by TangJR on 7/3/15.
//  Copyright (c) 2015 tangjr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBigHeadView : UIView

@property (assign, nonatomic) CGFloat lineWidth;

- (void)startDrawing;
- (void)endDrawing;
- (void)continueDrawing;
- (void)clearDrawing;

@end