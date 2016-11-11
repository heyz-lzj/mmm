//
//  GoodsDetailsViewController.h
//  miniu
//
//  Created by SimMan on 4/27/15.
//  Copyright (c) 2015 SimMan. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderEntity.h"
#import "GoodsEntity.h"
@class HomeCollectionViewCellFrame;

@interface GoodsDetailsViewController : BaseViewController<UIScrollViewDelegate>

@property (nonatomic, strong) HomeCollectionViewCellFrame *cellFrame;
@property (nonatomic, strong) UIScrollView *imgPlyer;
@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, strong) UIScrollView *viewScroll;
@property (nonatomic, strong) UIView *custView;  //自定义视图
@property (nonatomic, strong) UIPageControl *control;

@property (nonatomic, strong) GoodsEntity *goodsEntity;

@property (nonatomic, assign) long long goodsId;

/**
 *  订单实体
 */
@property (nonatomic, strong) OrderEntity *order;


/**
 *  创建订单详情页面方法
 *  2015.09.24
 *  @param order实体
 *
 *  @return 返回实例
 */
- (instancetype)initWithOrder:(OrderEntity *)order;

@end
