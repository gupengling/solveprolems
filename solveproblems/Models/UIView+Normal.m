//
//  UIView+Normal.m
//  solveproblems
//
//  Created by 51offer on 16/1/28.
//  Copyright © 2016年 Jahnny. All rights reserved.
//

#import "UIView+Normal.h"

@implementation UIView (Normal)
/**普通画圆角*/
+ (void)drawCircle:(UIView *)v radius:(CGFloat)r borderWidth:(CGFloat)bw borderColor:(UIColor *)bc{
    v.layer.masksToBounds = YES;
    v.layer.borderWidth = bw;
    v.layer.borderColor = [bc CGColor];
    v.layer.cornerRadius = r;
}

/**可不四边都画圆角
 * [self drawMaskTo:yourView byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
 */
+ (void)drawMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners {
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                  byRoundingCorners:corners
                                                        cornerRadii:CGSizeMake(6.0, 6.0)];
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    view.layer.mask = shape;
    
    
    //    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds
    //                                                   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
    //                                                         cornerRadii:CGSizeMake(6, 6)];
    //    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //    maskLayer.frame = imageView.bounds;
    //    maskLayer.path = maskPath.CGPath;
    //
    //    imageView.layer.mask = maskLayer;

}

@end
