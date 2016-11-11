//
//  BaseCollectionViewController.m
//  miniu
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 SimMan. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import "MJRefresh.h"
#import "MyLayout.h"

@interface BaseCollectionViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>{
    void (^_headerAction) ();
    void (^_footerAction) ();
    BOOL autoRefresh;
    CGFloat _oldPanOffsetY;
}

@end

@implementation BaseCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        autoRefresh = YES;
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
        self.pageNum = 1;
    }
    return self;
}

- (void)initControllerData{};

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customCollection];
    
    // 消除多余的 cell 横线
    //[self setExtraCellLineHidden:self.collectionView];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)customCollection
{
    MyLayout *layout = [[MyLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //self.collectionView.separatorStyle = UICollectionViewCellSeparatorStyleNone;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth
    |UIViewAutoresizingFlexibleHeight;
    
//    if (IS_IOS7) {
//        [self.collectionView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if (IS_IOS8) {
//      if ([self.collectionView respondsToSelector:@selector(setSeparatorInset:)]) {
//            [self.collectionView setSeparatorInset:UIEdgeInsetsMake(0,-20,0,0)];
//        }
//        
//        if ([self.collectionView respondsToSelector:@selector(setLayoutMargins:)]) {
//            [self.collectionView setLayoutMargins:UIEdgeInsetsMake(0,-20,0,0)];
//        }
//    }
    
    [self.view addSubview:self.collectionView];
}

//- (void)setExtraCellLineHidden: (UICollectionView *)collectionView
//{
//    UIView *view = [UIView new];
//    view.backgroundColor = [UIColor clearColor];
//    [collectionView setCollectionFooterView:view];
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (NSInteger)numberOfSectionsIncollectionView:(UICollectionView *)collectionView
{
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"collectionViewcell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
        //cell.selectionStyle = UICollectionViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark 自动加载更多
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row + 4 == [self.dataArray count] && [self.dataArray count] >= 5) {
        if (!self.collectionView.footer.isRefreshing) {
            [self.collectionView.footer beginRefreshing];
        }
    }
//    
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark 上拉加载，下拉刷新
- (void) addRefreshBlockWithHeader:(void (^)())headerAction AndFooter:(void (^)())footerAction autoRefresh:(BOOL)autoRe
{
    _headerAction = headerAction;
    _footerAction = footerAction;
    autoRefresh = autoRe;
    
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    if (_headerAction) {
        WeakSelf
        
        [self.collectionView addGifHeaderWithRefreshingBlock:^{
            [weakSelf_SC headerRereshing];
        }];
        
        self.collectionView.header.updatedTimeHidden = YES;
        self.collectionView.header.stateHidden = YES;
        
        // 设置普通状态的动画图片
        NSMutableArray *idleImages = [NSMutableArray array];
        for (NSUInteger i = 0; i<=17; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"风车%lu.png", i % 9 + 1]];
            [idleImages addObject:image];
        }
        [self.collectionView.gifHeader setImages:idleImages forState:MJRefreshHeaderStateIdle];
        
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        NSMutableArray *refreshingImages = [NSMutableArray array];
        for (NSUInteger i = 0; i<=17; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"风车%lu.png", i % 9 + 1]];
            [refreshingImages addObject:image];
        }
        [self.collectionView.gifHeader setImages:refreshingImages forState:MJRefreshHeaderStatePulling];
        
        // 设置正在刷新状态的动画图片
        [self.collectionView.gifHeader setImages:refreshingImages forState:MJRefreshHeaderStateRefreshing];
    }
    
    // 是否自动加载
    if (autoRefresh && _headerAction) {
        [self.collectionView.header beginRefreshing];
    }
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    if (_footerAction && !self.collectionView.legendFooter) {
        WeakSelf
        
        [self.collectionView addLegendFooterWithRefreshingBlock:^{
            [weakSelf_SC footerRereshing];
        }];
        
        //        // 设置正在刷新状态的动画图片
        //        NSMutableArray *refreshingImages = [NSMutableArray array];
        //        for (NSUInteger i = 1; i<=3; i++) {
        //            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        //            [refreshingImages addObject:image];
        //        }
        //        self.collectionView.gifFooter.refreshingImages = refreshingImages;
    }
}

- (void) addRefreshBlockWithFooter:(void (^)())footerAction
{
    
    _footerAction = footerAction;
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    if (_footerAction && !self.collectionView.legendFooter) {
        WeakSelf
        
        [self.collectionView addLegendFooterWithRefreshingBlock:^{
            [weakSelf_SC footerRereshing];
        }];
        
        //        // 设置正在刷新状态的动画图片
        //        NSMutableArray *refreshingImages = [NSMutableArray array];
        //        for (NSUInteger i = 1; i<=3; i++) {
        //            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        //            [refreshingImages addObject:image];
        //        }
        //        self.collectionView.gifFooter.refreshingImages = refreshingImages;
    }
}


- (void)headerRereshing
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endRefresh) name:NetWorkTaskFinish object:nil];
    _headerAction();
}

- (void)footerRereshing
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endRefresh) name:NetWorkTaskFinish object:nil];
    if(_footerAction){
        _footerAction();
    };
}

- (void)endRefresh
{
    
    
    if (self.collectionView.header.isRefreshing) {
        [self.collectionView.header endRefreshing];
    }
    
    if (self.collectionView.footer.isRefreshing) {
        [self.collectionView.footer endRefreshing];
    }
}

#pragma mark ScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self scrollWillScroll];
    _oldPanOffsetY = [scrollView.panGestureRecognizer translationInView:scrollView.superview].y;
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    _oldPanOffsetY = 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentSize.height <= CGRectGetHeight(scrollView.bounds)-50) {
        [self scrollWillDown];
        return;
    }else if (scrollView.panGestureRecognizer.state == UIGestureRecognizerStateChanged){
        CGFloat nowPanOffsetY = [scrollView.panGestureRecognizer translationInView:scrollView.superview].y;
        CGFloat diffPanOffsetY = nowPanOffsetY - _oldPanOffsetY;
        //        CGFloat contentOffsetY = scrollView.contentOffset.y;
        if (diffPanOffsetY > 0.f) {
            [self scrollWillDown];
        }else if (ABS(diffPanOffsetY) > 50.f) {
            [self scrollWillUp];
            _oldPanOffsetY = nowPanOffsetY;
        }
    }
}

- (void) scrollWillDown{}
- (void) scrollWillUp{}
- (void) scrollWillScroll{}

@end

