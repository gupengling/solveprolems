//
//  AMapViewListenerImpl.h
//  solveproblems
//
//  Created by 51offer on 16/1/19.
//  Copyright © 2016年 Jahnny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface AMapViewListenerImpl : MAMapView<MAMapViewDelegate>
- (void)removeAllAnnotations;
/**去往何处 的路径*/
- (void)toAnnotations:(CLLocationCoordinate2D)toplace;
@end
