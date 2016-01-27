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
        
        _tabViewSocial = [[RKTabView alloc] initWithFrame:CGRectMake(0, rect.size.height - 60, rect.size.width, 50) andTabItems:@[tabItemLoc,tabItemAdd,tabItemSet]];
        
////        间距
//        float w = (self.view.bounds.size.width-50*3)/2.;
//        _tabViewSocial.horizontalInsets = HorizontalEdgeInsetsMake(w, w);
        
        _tabViewSocial.horizontalInsets = HorizontalEdgeInsetsMake(100, 100);
        _tabViewSocial.drawSeparators = NO;
//        _tabViewSocial.enabledTabBackgrondColor = [UIColor colorWithRed:103.0f/256.0f green:87.0f/256.0f blue:226.0f/256.0f alpha:0.5];
        _tabViewSocial.enabledTabBackgrondColor = [UIColor colorWithWhite:1.f alpha:0.95f];

//        self.titledTabsView.horizontalInsets = HorizontalEdgeInsetsMake(25, 25);
        _tabViewSocial.titlesFontColor = UIColorFromRGB(0xffa846);
        _tabViewSocial.titlesFont = [UIFont boldSystemFontOfSize:10];
        
        _tabViewSocial.backgroundColor = [UIColor clearColor];

    }
    return _tabViewSocial;
}
#pragma mark - Button handler

- (void)buttonTabPressed:(id)sender {
    
}


- (UIView *)vList {
    if (_vList == nil) {
        CGRect rect = [UIScreen mainScreen].bounds;
        rect.origin.y += 65;
        rect.size.height -= 65;
        _vList = [[ListSearchView alloc] initWithFrame:rect];
        
        __strong ViewController *vcstrong = self;
        [_vList setBlocksForBack:^{
            __weak ViewController *vcweak = vcstrong;
            [vcweak btnNext:nil];
        }];
    }
    return _vList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.vList];
    [self.view addSubview:[GLOBAL mapView]];
    [GLOBAL mapView].showsUserLocation = YES;
    [GLOBAL mapView].userTrackingMode = MAUserTrackingModeFollow;
    [GLOBAL mapView].showsScale = YES;
    [GLOBAL mapView].showsCompass = YES;

    NSLog(@"dev test");
    [self initUI];
    [self bringNaviBarToTopmost];
    
    [self.view addSubview:self.tabViewSocial];
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
    [self setNaviBarTitle:@"Choose"];    // 设置标题
    
    UIButton *btnLeft = [CustomNaviBarView createNormalNaviBarBtnByTitle:@"search" target:self action:@selector(btnLeft:)];
    [self setNaviBarLeftBtn:btnLeft];       // 若不需要默认的返回按钮，直接赋nil
    
    // 创建一个自定义的按钮，并添加到导航条右侧。
    _btnNaviRight = [CustomNaviBarView createNormalNaviBarBtnByTitle:@"地图" target:self action:@selector(btnNext:)];
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
        
        
        
    }else {
        fromv = self.vList;
        tov = [GLOBAL mapView];
        options = UIViewAnimationOptionTransitionFlipFromRight;
        [_btnNaviRight setTitle:@"列表" forState:UIControlStateNormal];
    }
    [UIView transitionFromView:fromv toView:tov duration:0.36 options:options completion:^(BOOL finished) {
        [self bringNaviBarToTopmost];
        NSLog(@"fromv-->%@",fromv.superview);
        NSLog(@"tov-->%@",tov.superview);
        [self.vList reloadData:[[GLOBAL search] oldAnnotations]];
    }];
}
- (void)btnNext:(id)sender {
    
    
    
    
//    [[[GLOBAL search] oldAnnotations] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//    }];
    return;
    BaseVCInfo *info = [BaseVCInfo infoWithVCName:@"HomeViewController" storyboardName:@"Main" identifierName:@"HomeViewController"];
    BaseViewController *vc = [BaseViewController vcWithVCInfo:info];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnLeft:(id)sender {
    //定位到当前位置
    [[GLOBAL mapView] setCenterCoordinate:[GLOBAL mapView].userLocation.location.coordinate animated:YES];

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
