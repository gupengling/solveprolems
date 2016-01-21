//
//  AMapSearchListenerImpl.m
//  solveproblems
//
//  Created by 51offer on 16/1/19.
//  Copyright © 2016年 Jahnny. All rights reserved.
//

#import "AMapSearchListenerImpl.h"
#import "CommonUtility.h"
#import "MANaviRoute.h"

const NSInteger RoutePlanningPaddingEdge                    = 20;

@interface AMapSearchListenerImpl()

@end
@implementation AMapSearchListenerImpl
- (instancetype)init {
    self = [super init];
    if (self) {
        _oldAnnotations = [NSMutableArray array];
        [self setDelegate:self];
    }
    return self;
}
#pragma mark - AMapSearchDelegate

/**
 *  当请求发生错误时，会调用代理的此方法.
 *
 *  @param request 发生错误的请求.
 *  @param error   返回的错误.
 */
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"%s: searchRequest = %@, errInfo= %@", __func__, [request class], error);
}

/**
 *  POI查询回调函数
 *
 *  @param request  发起的请求，具体字段参考 AMapPOISearchBaseRequest 及其子类。
 *  @param response 响应结果，具体字段参考 AMapPOISearchResponse 。
 */
/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    NSLog(@"offset = %ld",(long)request.offset)
    NSLog(@"page = %ld",(long)request.page);
    [_oldAnnotations removeAllObjects];
    if (response.pois.count == 0)
    {
        return;
    }
    
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
        
    }];
    [_oldAnnotations addObjectsFromArray:poiAnnotations];
    
    /* 将结果以annotation的形式加载到地图上. */
    [[GLOBAL mapView] addAnnotations:poiAnnotations];
    
    /* 如果只有一个结果，设置其为中心点. */
    if (poiAnnotations.count == 1)
    {
        [[GLOBAL mapView] setCenterCoordinate:[poiAnnotations[0] coordinate]];
    }
    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
    else
    {
        [[GLOBAL mapView] showAnnotations:poiAnnotations animated:YES];
    }
}
/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    if ([request isKindOfClass:[AMapWalkingRouteSearchRequest class]]) {
        self.routePlanningType = AMapRoutePlanningTypeWalk;
    }
    self.route = response.route;

    [self presentCurrentCourse];

}
/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    /* 公交路径规划. */
    if (self.routePlanningType == AMapRoutePlanningTypeBus)
    {
        self.naviRoute = [MANaviRoute naviRouteForTransit:self.route.transits[0]];
    }
    /* 步行，驾车路径规划. */
    else
    {
        MANaviAnnotationType type = MANaviAnnotationTypeWalking;
        self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[0] withNaviType:type];
    }
    
    [self.naviRoute addToMapView:[GLOBAL mapView]];
    
    /* 缩放地图使其适应polylines的展示. */
    [[GLOBAL mapView] setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
                           animated:YES];

}
/* 清空地图上已有的路线. */
- (void)clearRoute
{
    [self.naviRoute removeFromMapView];
}

@end
