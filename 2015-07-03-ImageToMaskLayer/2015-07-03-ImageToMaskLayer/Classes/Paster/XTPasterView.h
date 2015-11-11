//
//  XTPasterView.h
//  XTPasterManager
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTPasterView ;

@protocol XTPasterViewDelegate <NSObject>

- (void)makePasterBecomeFirstRespond:(int)pasterID;
- (void)removePaster:(int)pasterID;
@end


@interface XTPasterView : UIView

@property (strong, nonatomic) UIImage *imagePaster;
@property (assign, nonatomic) int pasterID;
@property (assign, nonatomic) BOOL isOnFirst;
@property (weak, nonatomic) id <XTPasterViewDelegate> delegate;


- (instancetype)initWithBgView:(UIImageView *)bgView pasterID:(int)pasterID img:(UIImage *)img;
- (void)remove;

@end