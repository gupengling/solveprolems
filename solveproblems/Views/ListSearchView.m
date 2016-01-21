//
//  ListSearchView.m
//  solveproblems
//
//  Created by 51offer on 16/1/21.
//  Copyright © 2016年 Jahnny. All rights reserved.
//

#import "ListSearchView.h"
#import "POIAnnotation.h"

@interface ListSearchView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tabV;
@property (nonatomic, strong) NSMutableArray *arrData;

@property (nonatomic, copy) ListSearchBlock backBlock;
@end
@implementation ListSearchView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _arrData = [NSMutableArray array];
        
        self.tabV.delegate = self;
        self.tabV.dataSource = self;
        [self addSubview:self.tabV];
    }
    return self;
}

- (UITableView *)tabV {
    if (_tabV == nil) {
        _tabV = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tabV.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tabV.tableFooterView = [UIView new];
        _tabV.backgroundColor = [UIColor clearColor];
        _tabV.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _tabV;
}

- (void)reloadData:(NSMutableArray *)data {
    [_arrData removeAllObjects];
    [_arrData addObjectsFromArray:data];
    [self.tabV reloadData];
}
- (void)setBlocksForBack:(ListSearchBlock)back {
    _backBlock = [back copy];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    POIAnnotation *ann = [_arrData objectAtIndex:indexPath.row];
    [[GLOBAL mapView] toAnnotations:ann.coordinate];
    if (_backBlock) {
        _backBlock();
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrData count];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdetify = @"SvTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdetify];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.showsReorderControl = YES;
        cell.backgroundColor = self.backgroundColor;
    }
    POIAnnotation *ann = [_arrData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = ann.title;
    cell.detailTextLabel.text = ann.subtitle;
    
    return cell;
}
@end
