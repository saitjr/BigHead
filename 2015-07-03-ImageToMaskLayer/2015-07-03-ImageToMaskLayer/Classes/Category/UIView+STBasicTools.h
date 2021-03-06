//
//  UIView+TBasicTools.h
//  TKit
//
//  Created by TangJR on 15/5/3.
//  Copyright (c) 2015年 tangjr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (STBasicTools)

/**
 *  移除全部子视图
 */
- (void)st_removeAllSubviews;

/**
 *  获得当前所属控制器
 *
 *  @return 当前所属控制器
 */
- (UIViewController *)st_currentViewController;

/**
 *  截取当前view的图
 *
 *  @return 截取的图片
 */
- (UIImage *)st_screenShot;

@end