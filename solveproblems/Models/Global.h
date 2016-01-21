//
//  Global.h
//  solveproblems
//
//  Created by 51offer on 16/1/18.
//  Copyright © 2016年 Jahnny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMapSearchListenerImpl.h"
#import "AMapViewListenerImpl.h"

#define GLOBAL (Global *)[Global sharedInstance]

@interface Global : NSObject//<MAMapViewDelegate, AMapSearchDelegate>
GPL_H_SINGLETON(Global);


///map 相关
@property (nonatomic, strong) AMapViewListenerImpl *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) AMapSearchListenerImpl *search;

//@property (nonatomic, strong) AMapSearchAPI *search;

- (void)logAllVersion;

- (void)returnAction;
/**
 *  hook,子类覆盖它,实现想要在viewDidAppear中执行一次的方法,搜索中有用到
 */
- (void)hookAction;
- (NSString *)getApplicationName;
- (NSString *)getApplicationScheme;


/* 根据关键字来搜索POI. */
- (void)searchPoiByKeyword;
/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiByCenterCoordinate;

@end
