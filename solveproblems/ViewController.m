//
//  ViewController.m
//  solveproblems
//
//  Created by 51offer on 16/1/18.
//  Copyright © 2016年 Jahnny. All rights reserved.
//

#import "ViewController.h"
#import "CustomNaviBarView.h"

@interface ViewController ()<MAMapViewDelegate, AMapSearchDelegate>
@property (nonatomic, readonly) UIButton *btnNaviRight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initUI];
    
    [self.view addSubview:[GLOBAL mapView]];
    [GLOBAL mapView].showsUserLocation = YES;
    [GLOBAL mapView].userTrackingMode = MAUserTrackingModeFollow;
    [GLOBAL mapView].showsScale = YES;
    [GLOBAL mapView].showsCompass = YES;

    NSLog(@"dev test");
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
    [self setNaviBarLeftBtn:nil];       // 若不需要默认的返回按钮，直接赋nil
    
    // 创建一个自定义的按钮，并添加到导航条右侧。
    _btnNaviRight = [CustomNaviBarView createNormalNaviBarBtnByTitle:@"Home" target:self action:@selector(btnNext:)];
    [self setNaviBarRightBtn:_btnNaviRight];
}
- (void)btnNext:(id)sender {    
    
    [[GLOBAL mapView] setCenterCoordinate:[GLOBAL mapView].userLocation.location.coordinate animated:YES];
    [GLOBAL searchPoiByKeyword];
    return;
    BaseVCInfo *info = [BaseVCInfo infoWithVCName:@"HomeViewController" storyboardName:@"Main" identifierName:@"HomeViewController"];
    BaseViewController *vc = [BaseViewController vcWithVCInfo:info];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    
}

@end
