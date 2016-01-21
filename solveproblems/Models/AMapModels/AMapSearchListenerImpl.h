//
//  AMapSearchListenerImpl.h
//  solveproblems
//
//  Created by 51offer on 16/1/19.
//  Copyright © 2016年 Jahnny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "POIAnnotation.h"
@class MANaviRoute;
typedef NS_ENUM(NSInteger, AMapRoutePlanningType)
{
    AMapRoutePlanningTypeDrive = 0,
    AMapRoutePlanningTypeWalk,
    AMapRoutePlanningTypeBus
};

@interface AMapSearchListenerImpl : AMapSearchAPI<AMapSearchDelegate>

@property (nonatomic, assign) AMapRoutePlanningType routePlanningType;
/* 用于显示当前路线方案. */
@property (nonatomic, strong) MANaviRoute * naviRoute;
@property (nonatomic, strong) AMapRoute *route;
/* 清空地图上已有的路线. */
- (void)clearRoute;
@end
