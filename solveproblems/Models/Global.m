//
//  Global.m
//  solveproblems
//
//  Created by 51offer on 16/1/18.
//  Copyright © 2016年 Jahnny. All rights reserved.
//

#import "Global.h"
#import "AppDelegate.h"

@interface Global()
@property (nonatomic, assign) BOOL isFirstAppear;
@end
@implementation Global
GPL_M_SINGLETON(Global);
- (void)logAllVersion {
    [self startLocationManagerWithLocationBlock:^(id data) {
        
    } alertTitle:@""];
    
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _isFirstAppear = YES;
        [self configureAPIKey];
        [self initSearch];
        [self initMapView];

    }
    return self;
}

- (AMapViewListenerImpl *)mapView {
    if (_mapView == nil) {
//        _mapView = [[MAMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        CGRect rect = [UIScreen mainScreen].bounds;
        rect.origin.y += 65;
        rect.size.height -= 65;
        
        _mapView = [[AMapViewListenerImpl alloc] initWithFrame:rect];
        [_mapView setCompassImage:[UIImage imageNamed:@"compass"]];

//        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
//        {
//            self.locationManager = [[CLLocationManager alloc] init];
//            [self.locationManager requestAlwaysAuthorization];
//        }
    }
    return _mapView;
}
/* 初始化search. */
- (AMapSearchListenerImpl *)search {
    if (_search == nil) {
//        _search = [[AMapSearchAPI alloc] init];
        _search = [[AMapSearchListenerImpl alloc] init];
    }
    return _search;
}

- (void)configureAPIKey {
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
    [AMapSearchServices sharedServices].apiKey = (NSString *)APIKey;
}
#pragma mark - Utility

- (void)clearMapView
{
    self.mapView.showsUserLocation = NO;
    [self.mapView setCompassImage:nil];

    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    self.mapView.delegate = nil;
}

- (void)clearSearch
{
    self.search.delegate = nil;
}

/**
 *  hook,子类覆盖它,实现想要在viewDidAppear中执行一次的方法,搜索中有用到
 */
- (void)hookAction
{
    
}

#pragma mark - Handle Action

- (void)returnAction
{
    //    [self.navigationController popViewControllerAnimated:YES];
    
    self.mapView.userTrackingMode  = MAUserTrackingModeNone;
    
    [self.mapView removeObserver:self forKeyPath:@"showsUserLocation"];

    [self clearMapView];
    
    [self clearSearch];

}
- (void)initObservers
{
    /* Add observer for showsUserLocation. */
    [self.mapView addObserver:self forKeyPath:@"showsUserLocation" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - NSKeyValueObservering

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"showsUserLocation"])
    {
        //        NSNumber *showsNum = [change objectForKey:NSKeyValueChangeNewKey];
        //        self.mapView.showsUserLocation = YES;
    }
}

#pragma mark - Initialization

- (void)initMapView
{
//    self.mapView.frame = self.view.bounds;
    
//    self.mapView.delegate = self;
//    AMapViewListenerImpl *impl = [[AMapViewListenerImpl alloc] init];
//    [self.mapView setDelegate:impl];
    
//    [self.view addSubview:self.mapView];
    
    if (_isFirstAppear)
    {
        self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
        _isFirstAppear = NO;
        
        [self hookAction];
    }

}

- (void)initSearch
{
//    self.search.delegate = self;
    
//    AMapSearchListenerImpl* impl = [[AMapSearchListenerImpl alloc] init];
//    [self.search setDelegate:impl];
}





#pragma mark - Handle URL Scheme

- (NSString *)getApplicationName
{
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    return [bundleInfo valueForKey:@"CFBundleDisplayName"] ?: [bundleInfo valueForKey:@"CFBundleName"];
}

- (NSString *)getApplicationScheme
{
    NSDictionary *bundleInfo    = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier  = [[NSBundle mainBundle] bundleIdentifier];
    NSArray *URLTypes           = [bundleInfo valueForKey:@"CFBundleURLTypes"];
    
    NSString *scheme;
    for (NSDictionary *dic in URLTypes)
    {
        NSString *URLName = [dic valueForKey:@"CFBundleURLName"];
        if ([URLName isEqualToString:bundleIdentifier])
        {
            scheme = [[dic valueForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
            break;
        }
    }
    
    return scheme;
}

#pragma location
#pragma mark - location
//定位功能可用，开始定位
- (void)startLocationManagerWithLocationBlock:(void(^)(id data))locationBlock alertTitle:(NSString*)title{
    
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //定位功能可用，开始定位
            self.locationManager = nil;
            self.locationManager = [[CLLocationManager alloc] init];
            [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            //        _qlocmanager.distanceFilter = 0.01;//移动超过10米才调代理
            self.locationManager.distanceFilter=kCLDistanceFilterNone;
            self.locationManager.pausesLocationUpdatesAutomatically = YES;
            self.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
            //        _qlocmanager.activityType = CLActivityTypeFitness;
            [self.locationManager setDelegate:(id<CLLocationManagerDelegate>)self];

            if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
                [self.locationManager requestAlwaysAuthorization];
            }
            [self.locationManager startUpdatingLocation];
            [self.locationManager startUpdatingHeading];
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        NSLog(@"定位功能不可用，提示用户或忽略");
        if (title.length==0)
        {
            title=@"定位功能不可用，请开启定位";
        }
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"default" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (&UIApplicationOpenSettingsURLString != NULL) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }]];
        [MLNAVIGATION presentViewController:ac animated:YES completion:^{
            
        }];

        
        //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: UIApplicationOpenSettingsURLString]];
        //        double delayInSeconds = 1.0;
        //        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        //        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: UIApplicationOpenSettingsURLString]];
        //        });
        
    }
    
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
//            if (isIOS8) {
//                if ([_qlocmanager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//                    [_qlocmanager requestAlwaysAuthorization];
//                }
//            }
            break;
        default:
            break;
            
            
    }
}
- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error {
    NSString *errorString;
    [manager stopUpdatingLocation];
    NSLog(@"Error: %@",[error localizedDescription]);
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"访问定位服务被用户拒绝";//@"Access to Location Services denied by user";
            //Do something...
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"位置数据不可用";//@"Location data unavailable";
            //Do something else...
            break;
        default:
            errorString = @"定位出现未知错误";//@"An unknown error has occurred";
            break;
    }
}
#pragma mark - search poi info
/* 根据关键字来搜索POI. */
- (void)searchPoiByKeyword
{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.keywords            = @"上海大学";
    request.city                = @"上海";
    request.types               = @"高等院校";
    request.requireExtension    = YES;
    
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    
    [self.search AMapPOIKeywordsSearch:request];
}

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiByCenterCoordinate
{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
//    request.location            = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
    request.location            = [AMapGeoPoint locationWithLatitude:self.mapView.userLocation.coordinate.latitude longitude:self.mapView.userLocation.coordinate.longitude];
    request.keywords            = @"厕所|洗手间|酒店";//@"电影院";
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.requireExtension    = YES;
    
    [self.search AMapPOIAroundSearch:request];
}

@end
