//
//  BaseViewController.h
//  solveproblems
//
//  Created by 51offer on 16/1/18.
//  Copyright © 2016年 Jahnny. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomNavigationController.h"
#import "CustomViewController.h"
#import "CustomNaviBarView.h"


@interface BaseVCInfo : NSObject
@property (nonatomic, strong) NSString *vcName;
@property (nonatomic, strong) id contentObj;
@property (nonatomic, strong) id statusObj;
@property (nonatomic, assign) BOOL showXib;
@property (nonatomic, strong) NSString *storyboardName;
@property (nonatomic, strong) NSString *identifierName;
/**
 * 各种vc
 * @param 用于各种信息全的vc
 */
+ (id)infoWithVCName:(NSString *)name
             showXib:(BOOL)xib
      storyboardName:(NSString *)sbName
      identifierName:(NSString *)idName
          contentObj:(id)cObj
           statusObj:(id)sObj;
/**
 * 传值 适用于storyboard
 * @param 只用于storyboard 的vc 传值
 */
+ (id)infoWithVCName:(NSString *)name
      storyboardName:(NSString *)sbName
      identifierName:(NSString *)idName
          contentObj:(id)cObj
           statusObj:(id)sObj;
/**
 * 不传值 适用于storyboard
 * @param 只用于storyboard 的vc 不传值
 */
+ (id)infoWithVCName:(NSString *)name
      storyboardName:(NSString *)sbName
      identifierName:(NSString *)idName;
/**
 * 传值 适用于xib
 * @param 只用于xib 的vc 传值
 */
+ (id)infoWithVCName:(NSString *)name
          contentObj:(id)cObj
           statusObj:(id)sObj;
/**
 * 不传值 适用于xib
 * @param 只用于xib 的vc 不传值
 * infoWithVCName:
 */
+ (id)infoWithVCName:(NSString *)name;
@end
@interface BaseViewController : CustomViewController
@property (nonatomic, strong) BaseVCInfo *info; //数据对象
@property (nonatomic, strong) id obj;           //额外数据

#pragma mark - 主要设置
- (id)initWithVCInfo:(BaseVCInfo *)vcInfo;
+ (id)vcWithVCInfo:(BaseVCInfo *)vcInfo;

@end
