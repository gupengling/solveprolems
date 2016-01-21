//
//  HomeViewController.m
//  solveproblems
//
//  Created by 51offer on 16/1/18.
//  Copyright © 2016年 Jahnny. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
#pragma mark - CustomNaviBar UI
- (void)initUI
{
    [self setNaviBarTitle:@"Home"];    // 设置标题
    
    // 创建一个自定义的按钮，并添加到导航条右侧。
    UIButton *btnNaviRight = [CustomNaviBarView createNormalNaviBarBtnByTitle:@"Test" target:self action:@selector(btnNext:)];
    [self setNaviBarRightBtn:btnNaviRight];

}
- (void)btnNext:(id)sender {

    BaseVCInfo *info = [BaseVCInfo infoWithVCName:@"TestViewController" contentObj:@"content" statusObj:@"status"];
    BaseViewController *vc = [BaseViewController vcWithVCInfo:info];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}


@end
