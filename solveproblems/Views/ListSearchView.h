//
//  ListSearchView.h
//  solveproblems
//
//  Created by 51offer on 16/1/21.
//  Copyright © 2016年 Jahnny. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ListSearchBlock)();
@interface ListSearchView : UIView
- (void)reloadData:(NSMutableArray *)data;
- (void)setBlocksForBack:(ListSearchBlock)back;
@end
