//
//  BaseViewController.m
//  solveproblems
//
//  Created by 51offer on 16/1/18.
//  Copyright © 2016年 Jahnny. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseVCInfo
/*
 * @param 用于各种信息全的vc
 */
+ (id)infoWithVCName:(NSString *)name
             showXib:(BOOL)xib
      storyboardName:(NSString *)sbName
      identifierName:(NSString *)idName
          contentObj:(id)cObj
           statusObj:(id)sObj {
    
    BaseVCInfo *info = [[BaseVCInfo alloc] init];
    info.vcName = name;
    info.showXib = xib;
    info.contentObj = cObj;
    info.statusObj = sObj;
    if (xib == NO) {
        info.storyboardName = sbName;
        info.identifierName = idName;
    }
    return info;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

/*
 * @param 只用于storyboard 的vc 传值
 */
+ (id)infoWithVCName:(NSString *)name
      storyboardName:(NSString *)sbName
      identifierName:(NSString *)idName
          contentObj:(id)cObj
           statusObj:(id)sObj{
    return [self infoWithVCName:name showXib:NO storyboardName:sbName identifierName:idName contentObj:cObj statusObj:sObj];
}

/*
 * @param 只用于storyboard 的vc 不传值
 */
+ (id)infoWithVCName:(NSString *)name
      storyboardName:(NSString *)sbName
      identifierName:(NSString *)idName {
    return [self infoWithVCName:name showXib:NO storyboardName:sbName identifierName:idName contentObj:nil statusObj:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

/*
 * @param 只用于xib 的vc 传值
 */
+ (id)infoWithVCName:(NSString *)name
          contentObj:(id)cObj
           statusObj:(id)sObj {
    return [self infoWithVCName:name showXib:YES storyboardName:nil identifierName:nil contentObj:cObj statusObj:sObj];
}

/*
 * @param 只用于xib 的vc 不传值
 */
+ (id)infoWithVCName:(NSString *)name {
    return [self infoWithVCName:name showXib:YES storyboardName:nil identifierName:nil contentObj:nil statusObj:nil];
}

@end

@interface BaseViewController ()

@end

@implementation BaseViewController
//初始化vc对象
- (id)initWithVCInfo:(BaseVCInfo *)vcInfo {
    if (vcInfo.showXib) {
//        xibName = [vcInfo.vcName stringByAppendingString:@"iPad"];
        self = [super initWithNibName:vcInfo.vcName bundle:nil];
    }else {
        if (vcInfo.storyboardName.length > 0 && vcInfo.identifierName.length > 0) {
            //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
            UIStoryboard *story = [UIStoryboard storyboardWithName:vcInfo.storyboardName bundle:[NSBundle mainBundle]];
            //由storyboard根据myView的storyBoardID来获取我们要切换的视图
//            UIViewController *myView
            self = [story instantiateViewControllerWithIdentifier:vcInfo.identifierName];
        }else {
            self = [super init];
        }
    }
    if (self) {
        self.info = vcInfo;
    }
    return self;
}
/*
 * 初始化vc对象
 */
+ (id)vcWithVCInfo:(BaseVCInfo *)vcInfo {
    Class vc = NSClassFromString(vcInfo.vcName);
    return [[vc alloc] initWithVCInfo:vcInfo];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.viewNaviBar && !self.viewNaviBar.hidden) {
        [self bringNaviBarToTopmost];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Custom Navigation bar set

- (void)bringNaviBarToTopmost
{
    if (self.viewNaviBar)
    {
        [self.view bringSubviewToFront:self.viewNaviBar];
    }else{}
}
- (void)hideNaviBar:(BOOL)bIsHide
{
    self.viewNaviBar.hidden = bIsHide;
}

- (void)setNaviBarTitle:(NSString *)strTitle
{
    if (self.viewNaviBar)
    {
        [self.viewNaviBar setTitle:strTitle];
    }else{
    }
}

- (void)setNaviBarLeftBtn:(UIButton *)btn
{
    if (self.viewNaviBar)
    {
        [self.viewNaviBar setLeftBtn:btn];
    }else{APP_ASSERT_STOP}
}

- (void)setNaviBarRightBtn:(UIButton *)btn
{
    if (self.viewNaviBar)
    {
        [self.viewNaviBar setRightBtn:btn];
    }else{APP_ASSERT_STOP}
}
// 是否可右滑返回
- (void)navigationCanDragBack:(BOOL)bCanDragBack
{
    if (self.navigationController)
    {
        [((CustomNavigationController *)(self.navigationController)) navigationCanDragBack:bCanDragBack];
    }else{}
}


- (void)dealloc {
    [UtilityFunc cancelPerformRequestAndNotification:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
