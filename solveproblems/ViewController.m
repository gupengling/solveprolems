//
//  ViewController.m
//  solveproblems
//
//  Created by 51offer on 16/1/18.
//  Copyright © 2016年 Jahnny. All rights reserved.
//

#import "ViewController.h"
#import "CustomNaviBarView.h"

#import "ListSearchView.h"
#import "RKTabView.h"
typedef NS_ENUM(NSInteger, ItemType)
{
    ItemTypeLoc = 0,
    ItemTypeAdd,
    ItemTypeSet
};

@interface ViewController ()<MAMapViewDelegate, AMapSearchDelegate>
@property (nonatomic, readonly) UIButton *btnNaviRight;

@property (nonatomic, strong) ListSearchView *vList;

@property (nonatomic, strong) RKTabView* tabViewSocial;

@end

@implementation ViewController

//tabbar menu
- (RKTabView *)tabViewSocial {
    if (_tabViewSocial == nil) {
        CGRect rect = [UIScreen mainScreen].bounds;

        RKTabItem *tabItemLoc = [RKTabItem createButtonItemWithImage:[UIImage imageNamed:@"location"] target:self selector:@selector(buttonTabPressed:)];
        tabItemLoc.titleString = @"定位";

        RKTabItem *tabItemAdd = [RKTabItem createButtonItemWithImage:[UIImage imageNamed:@"add"] target:self selector:@selector(buttonTabPressed:)];
        tabItemAdd.titleString = @"添加";
        
        RKTabItem *tabItemSet = [RKTabItem createButtonItemWithImage:[UIImage imageNamed:@"set"] target:self selector:@selector(buttonTabPressed:)];
        tabItemSet.titleString = @"设置";
        
        
        _tabViewSocial = [[RKTabView alloc] initWithFrame:CGRectMake(80, rect.size.height - 60, rect.size.width-160, 50) andTabItems:@[tabItemLoc,tabItemAdd,tabItemSet]];
        
////        间距
//        _tabViewSocial.horizontalInsets = HorizontalEdgeInsetsMake(100, 100);
        _tabViewSocial.drawSeparators = NO;
        _tabViewSocial.enabledTabBackgrondColor = [UIColor clearColor];//[UIColor colorWithWhite:1.f alpha:0.95f];

//        self.titledTabsView.horizontalInsets = HorizontalEdgeInsetsMake(25, 25);
        _tabViewSocial.titlesFontColor = [UIColor titleColor];//UIColorFromRGB(0xffa846);
        _tabViewSocial.titlesFont = [UIFont boldSystemFontOfSize:10];
        
        _tabViewSocial.backgroundColor = [UIColor clearColor];
        
        
        
        //阴影加圆边
        _tabViewSocial.layer.borderWidth  = 0;
        _tabViewSocial.layer.cornerRadius = 4;
        _tabViewSocial.layer.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.9f].CGColor;
        //    imageView.layer.borderColor= [[UIColor redColor] CGColor];
        [_tabViewSocial.layer setShadowOffset:CGSizeMake(0, 0)];//表示四边
        [_tabViewSocial.layer setShadowOpacity:0.6];
        [_tabViewSocial.layer setShadowColor:[UIColor blackColor].CGColor];
        _tabViewSocial.layer.masksToBounds = YES;

    }
    return _tabViewSocial;
}
#pragma mark - Button handler

- (void)buttonTabPressed:(id)sender {
    NSInteger tag = [(UIButton *)sender tag];
    switch (tag) {
        case ItemTypeLoc: {
            //定位到当前位置
            [[GLOBAL mapView] setCenterCoordinate:[GLOBAL mapView].userLocation.location.coordinate animated:YES];
//            if ([GLOBAL mapView].userTrackingMode == MAUserTrackingModeFollow) {
//                [GLOBAL mapView].userTrackingMode = MAUserTrackingModeFollowWithHeading;
//            }else {
//                [GLOBAL mapView].userTrackingMode = MAUserTrackingModeFollow;
//            }

            break;
        }
        case ItemTypeAdd: {
            
            break;
        }
        case ItemTypeSet: {
            BaseVCInfo *info = [BaseVCInfo infoWithVCName:@"SettingViewController" storyboardName:@"Main" identifierName:@"SettingViewController"];
            BaseViewController *vc = [BaseViewController vcWithVCInfo:info];
            
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}


- (UIView *)vList {
    if (_vList == nil) {
        CGRect rect = [UIScreen mainScreen].bounds;
        rect.origin.y += self.viewNaviBar.frame.size.height;
        rect.size.height -= self.viewNaviBar.frame.size.height;
        _vList = [[ListSearchView alloc] initWithFrame:rect];
        _vList.backgroundColor = [UIColor whiteColor];
        __strong ViewController *vcstrong = self;
        [_vList setBlocksForBack:^{
            __weak ViewController *vcweak = vcstrong;
            [vcweak btnNext:nil];
        }];
    }
    return _vList;
}
- (void)showList:(BOOL)show {
    CGFloat y = self.viewNaviBar.frame.size.height;
    CGFloat ytab = ScreenHeight - 60;
    
    self.vList.hidden = NO;
//    if (self.vList.frame.origin.y > 0){
    if (show == NO) {
        y = - self.vList.frame.size.height;
    }else {
        ytab = ScreenHeight+2;
        [self.vList reloadData:[[GLOBAL search] oldAnnotations]];
    }
    
    [UIView animateWithDuration:0.36 animations:^{
        CGRect framevl = self.vList.frame;
        framevl.origin.y = y;
        [self.vList setFrame:framevl];
        
        CGRect frame = self.tabViewSocial.frame;
        frame.origin.y = ytab;
        [self.tabViewSocial setFrame:frame];
    } completion:^(BOOL finished) {
        self.vList.hidden = !show;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:[GLOBAL mapView]];

    [GLOBAL mapView].showsUserLocation = YES;
    [GLOBAL mapView].userTrackingMode = MAUserTrackingModeFollow;
    [GLOBAL mapView].showsScale = YES;
    [GLOBAL mapView].showsCompass = YES;
//    [GLOBAL mapView].alpha = 0.3;
    NSLog(@"dev test");
    
    
    [self.view addSubview:self.vList];

    [self.view addSubview:self.tabViewSocial];

    
    [[GLOBAL mapView] sendSubviewToBack:self.vList];

    
    [self initUI];
    [self bringNaviBarToTopmost];
    

    [self showList:NO];
    
    
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - CustomNaviBar UI
- (void)initUI
{
    [self setNaviBarTitle:@"Find"];    // 设置标题
    
    UIButton *btnLeft = [CustomNaviBarView createNormalNaviBarBtnByTitle:@"search" target:self action:@selector(btnLeft:)];
    [self setNaviBarLeftBtn:btnLeft];       // 若不需要默认的返回按钮，直接赋nil
    
    // 创建一个自定义的按钮，并添加到导航条右侧。
    _btnNaviRight = [CustomNaviBarView createNormalNaviBarBtnByTitle:@"列表" target:self action:@selector(btnNext:)];
    [self setNaviBarRightBtn:_btnNaviRight];
}
- (void)changeToSwitchView {
    UIView *fromv = nil;
    UIView *tov = nil;
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionNone;
    if ([GLOBAL mapView].superview) {
        fromv = [GLOBAL mapView];
        tov = self.vList;
        options = UIViewAnimationOptionTransitionFlipFromLeft;
        [_btnNaviRight setTitle:@"地图" forState:UIControlStateNormal];
        
        self.tabViewSocial.hidden = YES;
    }else {
        fromv = self.vList;
        tov = [GLOBAL mapView];
        options = UIViewAnimationOptionTransitionFlipFromRight;
        [_btnNaviRight setTitle:@"列表" forState:UIControlStateNormal];
        self.tabViewSocial.hidden = NO;
        [self.view bringSubviewToFront:self.tabViewSocial];
    }
    [UIView transitionFromView:fromv toView:tov duration:0.36 options:options completion:^(BOOL finished) {
        [self bringNaviBarToTopmost];
        NSLog(@"fromv-->%@",fromv.superview);
        NSLog(@"tov-->%@",tov.superview);
        if (self.vList.superview) {
            [self.vList reloadData:[[GLOBAL search] oldAnnotations]];
        }else {
            [self.view bringSubviewToFront:self.tabViewSocial];
        }
    }];
}
- (void)btnNext:(id)sender {
    
//    [self changeToSwitchView];
    [self showList:self.vList.hidden];
    
//    [[[GLOBAL search] oldAnnotations] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//    }];
    return;
    BaseVCInfo *info = [BaseVCInfo infoWithVCName:@"HomeViewController" storyboardName:@"Main" identifierName:@"HomeViewController"];
    BaseViewController *vc = [BaseViewController vcWithVCInfo:info];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnLeft:(id)sender {

    [[GLOBAL search] clearRoute];
    [[GLOBAL mapView] removeAllAnnotations];
    //根据周边搜索
    [GLOBAL searchPoiByCenterCoordinate];
    
//    //关键字搜索
//    [GLOBAL searchPoiByKeyword];

}
#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    
}

@end
