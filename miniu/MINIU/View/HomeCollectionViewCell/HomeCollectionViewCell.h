//
//  HomeCollectionViewCell.h
//  miniu
//
//  Created by Apple on 15/10/29.
//  Copyright © 2015年 SimMan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeCollectionViewCellFrame.h"

@class HomeCollectionViewCell;

@protocol HomeCollectionViewCellDelegate <NSObject>

#if TARGET_IS_MINIU_BUYER //不知道为何报错

- (void) didDeleteWithCell:(HomeCollectionViewCell *)cell;
#endif

- (void) didSelectTagName:(NSString *)tagName;
@end

typedef void(^FavotitBtn)(UIButton *btn);

@interface HomeCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) id<HomeCollectionViewCellDelegate> delegate;


@property (nonatomic, strong) HomeCollectionViewCellFrame *cellFrame;

//@property (nonatomic, assign) CGSize cellSize;

@property (nonatomic,strong) UIImageView *showImage;   //展示图片

@property (nonatomic,strong) UIButton *favoritBtn;     //收藏按钮

@property (nonatomic,strong) UILabel *goodsTitle;      //商品标题

@property (nonatomic,strong) UILabel *origin;       //原价汉字

@property (nonatomic,strong) UILabel *pre;       //优惠价汉字

@property (nonatomic,strong) UILabel *origPrice;       //原价

@property (nonatomic,strong) UILabel *prefPrice;       //优惠价

@property (nonatomic,strong) UIButton *touchBtn;

@property (nonatomic, strong) GoodsEntity *goods;

@property (nonatomic, copy) void (^desTapBlock)(HomeCollectionViewCell *);

@property (nonatomic, copy) void (^touchBllock)(NSInteger tag);

//block属性
@property (nonatomic,copy) FavotitBtn btn;
//自定义block方法
- (void)handleBUttonAction:(FavotitBtn)block;

-(void)addTapDesBlock:(void(^)(HomeCollectionViewCell *cell))block;

@end
