//
//  UIView+Normal.h
//  solveproblems
//
//  Created by 51offer on 16/1/28.
//  Copyright © 2016年 Jahnny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Normal)

/**普通画圆角*/
+ (void)drawCircle:(UIView *)v radius:(CGFloat)r borderWidth:(CGFloat)bw borderColor:(UIColor *)bc;
/**可不四边都画圆角
 * [self setMaskTo:yourView byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
 */
+ (void)drawMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners;
@end
