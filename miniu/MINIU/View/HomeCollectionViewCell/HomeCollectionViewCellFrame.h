//
//  HomeCollectionViewCellFrame.h
//  miniu
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 SimMan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GoodsEntity.h"

@class HomeCollectionViewCellFrame;


@interface HomeCollectionViewCellFrame : UICollectionViewFlowLayout

@property (nonatomic, assign) CGSize cellSize;

@property (nonatomic, assign) CGRect showImageViewFrame;
@property (nonatomic, assign) CGRect origLableFrame;
@property (nonatomic, assign) CGRect origPriceLableFrame;
@property (nonatomic, assign) CGRect preLableFrame;
@property (nonatomic, assign) CGRect prePriceLableFrame;
@property (nonatomic, assign) CGRect titelLableFrame;
@property (nonatomic, assign) CGRect favoritButtonFrame;

@property (nonatomic, strong)UIImage *img;

@property (nonatomic, strong) GoodsEntity *goodsEntity;


//初始化创建单元格
- (instancetype) initWithObject:(GoodsEntity *)goodsEntity;
@end

