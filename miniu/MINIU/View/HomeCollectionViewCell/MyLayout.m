//
//  MyLayout.m
//  miniu
//
//  Created by Apple on 15/11/4.
//  Copyright © 2015年 SimMan. All rights reserved.
//

#import "MyLayout.h"

#define ITEM_SIZE 70
#define MARGIN 10

@implementation MyLayout

-(void)prepareLayout
{
    [super prepareLayout];
    
    self.itemWidth= (kScreen_Width - MARGIN*1.5)/2;
    
    self.sectionInset=UIEdgeInsetsMake(5, 5, 5, 5);
    self.delegate = (id <WaterFLayoutDelegate> )self.collectionView.delegate;
    CGSize size = self.collectionView.frame.size;
    _cellCount = [[self collectionView] numberOfItemsInSection:0];
    _center = CGPointMake(size.width / 2.0, size.height / 2.0);
    _radius = MIN(size.width, size.height) / 2.5;
}

-(CGSize)collectionViewContentSize
{
    return CGSizeMake(kScreen_Width, (leftY>rightY?leftY:rightY));
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath  withIndex:(int)index
{
    //得到单元各大小
    CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    CGFloat itemHeight = floorf(itemSize.height * self.itemWidth / itemSize.width);
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    if (leftY <= rightY)
    {
        x=0;
        x = self.sectionInset.left;
        
        leftY += self.sectionInset.top;
        
        attributes.frame = CGRectMake(x, leftY, self.itemWidth, itemHeight);
        
        leftY += itemHeight;
    }
    else
    {
        x=0;
        x += (self.itemWidth+self.sectionInset.left*2);
        
        rightY += self.sectionInset.top;
        
        attributes.frame = CGRectMake(x, rightY, self.itemWidth, itemHeight);
        
        rightY += itemHeight;
    }
    return attributes;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    x=0;
    
    leftY=0;
    
    rightY=0;
    
    NSMutableArray* attributes = [NSMutableArray array];
    NSLog(@"cellCount=%ld",(long)self.cellCount);
    for (NSInteger i=0 ; i < self.cellCount; i++) {
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath withIndex:i]];
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForInsertedItemAtIndexPath:(NSIndexPath*)itemIndexPath
{
    
    UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0.0;
    
    attributes.center = CGPointMake(_center.x, _center.y);
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDeletedItemAtIndexPath:(NSIndexPath*)itemIndexPath
{
    
    UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0.0;
    
    attributes.center = CGPointMake(_center.x, _center.y);
    
    attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
    
    return attributes;
}
@end