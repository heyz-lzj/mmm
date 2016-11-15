//
//  HomeCollectionViewCellFrame.m
//  miniu
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 SimMan. All rights reserved.
//

#import "HomeCollectionViewCellFrame.h"
#import "GoodsEntity.h"
#import "NSString+Common.h"
#import "UIImageView+WebCache.h"
#import "GetImageSize.h"
#import "AFHTTPRequestOperation.h"

#define Left_MARGIN 5
#define right_MARGIN 5
#define Top_MARGIN 3
#define Bottom_MARGIN 3
#define FONT_HEIGHT1 14
#define FONT_HEIGHT2 18
#define FONT_HEIGHT3 25


@interface HomeCollectionViewCellFrame()
@property(nonatomic,retain)NSMutableDictionary * maxYdic;
@end


@implementation HomeCollectionViewCellFrame


- (instancetype) initWithObject:(GoodsEntity *)goodsEntity
{
    self = [super init];
    if (self) {
        self.goodsEntity = goodsEntity;
        
        self.showImageViewFrame = CGRectZero;   //显示图
        self.favoritButtonFrame = CGRectZero;   //收藏按钮
        self.origLableFrame = CGRectZero;       //专柜价(汉字)
        self.origPriceLableFrame = CGRectZero;  //专柜价(价格)
        self.preLableFrame = CGRectZero;        //优惠价(汉字)
        self.prePriceLableFrame = CGRectZero;   //优惠价(价格)
        self.titelLableFrame = CGRectZero;       //商品标题
        
       // self.sectionInset = UIEdgeInsetsMake(0, 8 , 8 , 0);
        
        [self calculateSize];
    }
    return self;
}

#pragma mark 计算尺寸
- (void) calculateSize
{
    [self showImageViewFrame];
    
    
    // 显示图
    CGFloat showImageViewW = (kScreen_Width - 2 * Left_MARGIN -2 * right_MARGIN - 3*5)/2;
    NSString *str = [NSString stringWithFormat:@"%@?imageInfo",_goodsEntity.firstImageUrl];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *imageInfo = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
    CGFloat width = [[imageInfo objectForKey:@"width"] integerValue];
    CGFloat heigh = [[imageInfo objectForKey:@"height"] integerValue];
    CGFloat showImageViewH = heigh/width * showImageViewW;
    _showImageViewFrame = CGRectMake(Left_MARGIN, Top_MARGIN, showImageViewW, showImageViewH);

    
    //收藏按钮
    CGFloat favoritBtnX = showImageViewW - 35;
    CGFloat favoritBtnY = Top_MARGIN + 5;
    CGFloat favoritBtnW = 35;
    CGFloat favoritBtnH = 33;
    _favoritButtonFrame = CGRectMake(favoritBtnX, favoritBtnY, favoritBtnW, favoritBtnH);
    
    //商品标题
    CGFloat titleLableX = Left_MARGIN;
    CGFloat titleLableY = CGRectGetMaxY(_showImageViewFrame) + Bottom_MARGIN;
    CGFloat titleLableW = _showImageViewFrame.size.width;
    CGFloat titleLableH = FONT_HEIGHT2;
    _titelLableFrame = CGRectMake(titleLableX, titleLableY, titleLableW, titleLableH);
    
    // 专柜价(汉字)
    CGFloat origLableX = Left_MARGIN;
    CGFloat origLableY = CGRectGetMaxY(_titelLableFrame)+6;
    CGFloat origLableW = 40.0f;
    CGFloat origLableH = FONT_HEIGHT1;
    _origLableFrame = CGRectMake(origLableX, origLableY, origLableW, origLableH);
    
    // 专柜价
    CGFloat origPriceLableX = CGRectGetMaxX(_origLableFrame);
    CGFloat origPriceLableY = CGRectGetMaxY(_titelLableFrame) + 6;
    CGFloat origPriceLableW = 30.0f;
    CGFloat origPriceLableH = FONT_HEIGHT1;
    _origPriceLableFrame = CGRectMake(origPriceLableX, origPriceLableY, origPriceLableW, origPriceLableH);
    
    // 优惠价
    UIFont *font = [UIFont systemFontOfSize:17];
    CGSize size = CGSizeMake(320,2000);
    CGSize labelsize;
    if (_goodsEntity.isShowPrice) {
        labelsize  = [[NSString stringWithFormat:@"%@",_goodsEntity.price] sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    }else {
        labelsize = [@"询价请私信" sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    }
    CGFloat prefPriceLableW = labelsize.width;
    CGFloat prefPriceLableH = FONT_HEIGHT3;
    CGFloat prePriceLablex = (kScreen_Width - 3*Left_MARGIN)/2-prefPriceLableW;
    CGFloat prefPriceLableY = CGRectGetMaxY(_titelLableFrame) + 3;
    _prePriceLableFrame = CGRectMake(prePriceLablex, prefPriceLableY, prefPriceLableW, prefPriceLableH);
    
    // 优惠价(汉字)
    //CGFloat prefLableX = CGRectGetMaxX(_origPriceLableFrame)+20;
    if (_goodsEntity.isShowPrice) {
        CGSize preLabelSize = [@"￥￥" sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:size ];
        CGFloat prefLableW = preLabelSize.width+4;
        CGFloat prefLableH = FONT_HEIGHT2;
        CGFloat prefLableX = CGRectGetMinX(_prePriceLableFrame) - prefLableW;
        CGFloat prefLableY = CGRectGetMaxY(_titelLableFrame) + 6;
        _preLableFrame = CGRectMake(prefLableX, prefLableY, prefLableW, prefLableH);
    }
    
    // 计算 cell 的尺寸
    _cellSize = CGSizeMake((kScreen_Width - 3*5)/2, CGRectGetMaxY(_prePriceLableFrame));
}
@end
