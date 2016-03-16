//
//  AMapViewListenerImpl.m
//  solveproblems
//
//  Created by 51offer on 16/1/19.
//  Copyright © 2016年 Jahnny. All rights reserved.
//

#import "AMapViewListenerImpl.h"
#import "LineDashPolyline.h"
#import "MANaviRoute.h"

const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";
const NSInteger RoutePlanningPaddingEdge                    = 20;

@interface AMapViewListenerImpl()
@property (nonatomic, assign) CLLocationCoordinate2D toPlaceLocation;
@end
@implementation AMapViewListenerImpl
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDelegate:self];
    }
    return self;
}

#pragma mark - MAMapViewDelegate

- (void)mapViewWillStartLocatingUser:(MAMapView *)mapView {
//    mapView.userLocation
//    NSLog(@"title %@ ; subtitle %@; lat %f; lon %f",mapView.userLocation.title,mapView.userLocation.subtitle,mapView.userLocation.location.coordinate.latitude,mapView.userLocation.location.coordinate.longitude);
    
    NSLog(@"%f",self.zoomLevel);
    NSLog(@"%f",self.maxZoomLevel);
    NSLog(@"%f",self.minZoomLevel);
    [self setZoomLevel:18.3 animated:YES];
}
- (void)mapViewDidStopLocatingUser:(MAMapView *)mapView {
    
}
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    
}
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {

}


- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id<MAAnnotation> annotation = view.annotation;
    
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        POIAnnotation *poiAnnotation = (POIAnnotation*)annotation;
        
        //去往某处
        [self toAnnotations:poiAnnotation.coordinate];
        
//        PoiDetailViewController *detail = [[PoiDetailViewController alloc] init];
//        detail.poi = poiAnnotation.poi;
//        
//        /* 进入POI详情页面. */
//        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        static NSString *poiIdentifier = @"poiIdentifier";
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[[GLOBAL mapView] dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
            poiAnnotationView.pinColor = MAPinAnnotationColorGreen;
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return poiAnnotationView;
    }
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[[GLOBAL mapView] dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:routePlanningCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        
        if ([annotation isKindOfClass:[MANaviAnnotation class]])
        {
            switch (((MANaviAnnotation*)annotation).type)
            {
                case MANaviAnnotationTypeBus:
                    poiAnnotationView.image = [UIImage imageNamed:@"bus"];
                    break;
                    
                case MANaviAnnotationTypeDrive:
                    poiAnnotationView.image = [UIImage imageNamed:@"car"];
                    break;
                    
                case MANaviAnnotationTypeWalking:
                    poiAnnotationView.image = [UIImage imageNamed:@"man"];
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            /* 起点. */
            if ([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerStartTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
            }
            /* 终点. */
            else if([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerDestinationTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
            }
            
        }
        
        return poiAnnotationView;
    }
    return nil;
}
/*路径规划*/
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        
        polylineRenderer.lineWidth   = 7;
        polylineRenderer.strokeColor = [UIColor blueColor];
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 8;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = [GLOBAL search].naviRoute.walkingColor;
//            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        }
        else
        {
            polylineRenderer.strokeColor = [GLOBAL search].naviRoute.routeColor;
        }
        
        return polylineRenderer;
    }
    
    return nil;
}




//地图加起点个🏁
- (void)addDefaultAnnotations:(CLLocationCoordinate2D)toplace
{
    _toPlaceLocation = toplace;
    
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.userLocation.coordinate;
    startAnnotation.title      = (NSString*)RoutePlanningViewControllerStartTitle;
    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude];
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = toplace;
    destinationAnnotation.title      = (NSString*)RoutePlanningViewControllerDestinationTitle;
    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", toplace.latitude, toplace.longitude];
    
    [self addAnnotation:startAnnotation];
    [self addAnnotation:destinationAnnotation];
}

/* 步行路径规划搜索. */
- (void)searchRoutePlanningWalk
{
    
    AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
    
    /* 提供备选方案*/
    navi.multipath = 1;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.userLocation.coordinate.latitude
                                           longitude:self.userLocation.coordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:_toPlaceLocation.latitude
                                                longitude:_toPlaceLocation.longitude];
    
    [[GLOBAL search] AMapWalkingRouteSearch:navi];
}
- (void)removeAllAnnotations {
    [self removeAnnotations:self.annotations];
}
/**去往何处 的路径*/
- (void)toAnnotations:(CLLocationCoordinate2D)toplace {
    
    [[GLOBAL search] clearRoute];
    [self removeAllAnnotations];
    
    //将两点加入地图
    [self addDefaultAnnotations:toplace];
    //步行路径规划
    [self searchRoutePlanningWalk];

}
@end
