//
//  BaseCollectionViewController.h
//  miniu
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 SimMan. All rights reserved.
//

#import "BaseViewController.h"

//
//typedef enum  {
//    LOAD_MOREC = 0,    // 加载更多
//    LOAD_UPDATEC,           // 刷新
//} LOAD_TYPEC;

@interface BaseCollectionViewController : BaseViewController <UICollectionViewDataSource, UICollectionViewDelegate>

/**
 *  当前的CollectionView
 */
@property (nonatomic, retain) UICollectionView *collectionView;

/**
 *  当前的数据数组
 */
@property (nonatomic, retain) NSMutableArray *dataArray;

/**
 *  当前的页数
 */
@property (nonatomic, assign) NSUInteger pageNum;

/**
 *  下拉刷新与上拉加载更多 (如果为nil则取消)
 *
 *  @param headerAction 下拉
 *  @param footerAction 上拉
 *  @param autoRe       是否自动加载
 */
- (void) addRefreshBlockWithHeader:(void (^)())headerAction AndFooter:(void (^)())footerAction autoRefresh:(BOOL)autoRe;

/**
 *  @brief  添加一个Footer刷新
 *
 *  @param footerAction
 */
- (void) addRefreshBlockWithFooter:(void (^)())footerAction;

/**
 *  停止刷新
 */
- (void)endRefresh;

/**
 *  CustomCollectionView
 */
- (void)customCollection;

#pragma mark -

/**
 *  @brief  向上移动
 */
- (void) scrollWillUp;

/**
 *  @brief 向下移动
 */
- (void) scrollWillDown;

/**
 *  @brief 将要移动
 */
- (void) scrollWillScroll;

@end
