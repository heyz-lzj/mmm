//
//  OrderListTableViewCell.h
//  miniu
//
//  Created by SimMan on 15/6/4.
//  Copyright (c) 2015年 SimMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderEntity;

@interface OrderListTableViewCell : UITableViewCell

@property (nonatomic, strong) OrderEntity *order;
@property (nonatomic,strong) UILabel * separator;
@property (nonatomic, strong) UILabel *line;
- (void) tapAvatarImageViewCallBackBlock:(void(^)(OrderEntity *order))Block;

@end
