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

- (void)makePasterBecomeFirstRespond:(NSInteger)pasterID;
- (void)removePaster:(NSInteger)pasterID;

@end


@interface XTPasterView : UIView

@property (strong, nonatomic) UIImage *imagePaster;
@property (assign, nonatomic) NSInteger pasterID;
@property (assign, nonatomic) BOOL isOnFirst;
@property (weak, nonatomic) id <XTPasterViewDelegate> delegate;


- (instancetype)initWithBgView:(UIImageView *)bgView pasterID:(NSInteger)pasterID image:(UIImage *)image;
- (void)remove ;

@end