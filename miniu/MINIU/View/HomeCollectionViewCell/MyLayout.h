//
//  MyLayout.h
//  miniu
//
//  Created by Apple on 15/11/4.
//  Copyright © 2015年 SimMan. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark WaterF
@protocol WaterFLayoutDelegate <UICollectionViewDelegate,UICollectionViewDelegate>
@required
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForHeaderInSection:(NSInteger)section;

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForFooterInSection:(NSInteger)section;
@end

@interface MyLayout : UICollectionViewFlowLayout
{
    float x;
    float leftY;
    float rightY;
}
@property float itemWidth;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) NSInteger cellCount;
/// The delegate will point to collection view's delegate automatically.
@property (nonatomic, weak) id <WaterFLayoutDelegate> delegate;
/// Array to store attributes for all items includes headers, cells, and footers
@property (nonatomic, strong) NSMutableArray *allItemAttributes;
@property (nonatomic, assign) UIEdgeInsets sectionInset;
@end