//
//  AppDelegate.h
//  solveproblems
//
//  Created by 51offer on 16/1/18.
//  Copyright © 2016年 Jahnny. All rights reserved.
//

#import <UIKit/UIKit.h>
#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define MLNAVIGATION (((AppDelegate *)[UIApplication sharedApplication].delegate).navController)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;


@end

