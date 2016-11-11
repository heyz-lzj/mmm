//
//  OrderTableViewController.h
//  miniu
//
//  Created by SimMan on 15/7/1.
//  Copyright (c) 2015年 SimMan. All rights reserved.
//

#import "BaseTableViewController.h"

@interface OrderTableViewController : BaseTableViewController {
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *filterData;
}

@property (nonatomic, assign) long long withUserId;
@property (nonatomic,strong) UIView * separator;

@end
