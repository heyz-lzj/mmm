//
//  HomeViewController.h
//  miniu
//
//  Created by SimMan on 4/16/15.
//  Copyright (c) 2015 SimMan. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import "HeaderView.h"

@class HomeCollectionViewCell;
@interface HomeViewController : BaseCollectionViewController<UICollectionViewDataSource,UICollectionViewDelegate> {
    HeaderView *_headerView;
    //HomeCollectionViewCell *_cell;
}

@property (nonatomic, strong) NSString *tagName;

@end
