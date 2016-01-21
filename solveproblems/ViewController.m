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

@interface ViewController ()<MAMapViewDelegate, AMapSearchDelegate>
@property (nonatomic, readonly) UIButton *btnNaviRight;

@property (nonatomic, strong) ListSearchView *vList;
@end

@implementation ViewController

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
- (void)btnNext:(id)sender {
    
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
