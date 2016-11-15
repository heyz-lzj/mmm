//
//  HomeCollectionViewCell.m
//  miniu
//
//  Created by Apple on 15/10/29.
//  Copyright © 2015年 SimMan. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "UITTTAttributedLabel.h"
#import "UIAwesomeButton.h"
#import "MMPlaceHolder.h"
#import "GoodsEntity.h"
#import "UserEntity.h"
#import "NSDate+Category.h"
#import "UIAwesomeButton.h"
#import "RTLabel.h"
//#import "UIImageView+WebCache.h"
//#import "PhotoZooo.h"
#import "UIImageView+WebImage.h"


#import <QuartzCore/QuartzCore.h>


#define RandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

@implementation HomeCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self addSubview:self.showImage];
        [self addSubview:self.favoritBtn];
        [self addSubview:self.pre];
        [self addSubview:self.prefPrice];
       // [self addSubview:self.origin];
       // [self addSubview:self.origPrice];
        [self addSubview:self.goodsTitle];
        
        [self insertSubview:self.touchBtn belowSubview:self.favoritBtn];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellFrame:(HomeCollectionViewCellFrame *)cellFrame
{
    _cellFrame = cellFrame;
    
    _goods = _cellFrame.goodsEntity;
    
    _touchBtn.backgroundColor = [UIColor clearColor];
    _touchBtn.tag = self.tag;
    [_touchBtn addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 展示图片
   // _showImage.image = _cellFrame.img;
    NSString *str = [NSString stringWithFormat:@"%@!scale",_goods.firstImageUrl];
    NSURL *url = [NSURL URLWithString:str];
    [_showImage sd_setImageWithURL:url];
//    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//        _showImage.image = image;
//    }];

    // 标题
    [_goodsTitle setText:_goods.depictRemark];
    
    // 专柜价(汉字)
    _origin.textColor = [UIColor lightGrayColor];
    _origin.backgroundColor = [UIColor clearColor];
    _origin.font = [UIFont systemFontOfSize:11];
    [_origin setText:[NSString stringWithFormat:@"专柜价:"]];
    
    // 专柜价
    //NSString *origStr = @"暂无原价";
    _origPrice.textColor = [UIColor lightGrayColor];
    _origPrice.backgroundColor = [UIColor greenColor];
    _origPrice.font = [UIFont systemFontOfSize:11];
    [_origPrice setText:[NSString stringWithFormat:@"暂无原价"]];
    
    // 优惠价(汉字)
    [_pre setText:[NSString stringWithFormat:@"￥"]];
    _pre.backgroundColor = [UIColor colorWithRed:0.600 green:0.502 blue:0.900 alpha:1];
    //[UIColor colorWithPatternImage:[UIImage imageNamed:@"product_color_1_u390_selected"] ];
    _pre.textColor = [UIColor whiteColor];
    _pre.font = [UIFont systemFontOfSize:13];
    //_pre.backgroundColor = [UIColor colorWithRed:0.1 green:0.2 blue:0.3 alpha:1];

    // 优惠价
    NSString *priceStr = nil;
    if (_goods.isShowPrice) {
        priceStr = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@",_goods.price]];

    } else {
        priceStr = @"询价请私信 ";
        //_prefPrice.font = [UIFont systemFontOfSize:14];
    }
    _prefPrice.font = [UIFont systemFontOfSize:15];

    _prefPrice.backgroundColor = [UIColor clearColor];
    _prefPrice.textAlignment = NSTextAlignmentCenter;
    
    [_prefPrice setText:[NSString stringWithFormat:@"%@",priceStr]];

    
     //收藏按钮
    [_favoritBtn setSelected:self.cellFrame.goodsEntity.isMyLike];
}

- (void)touchAction:(UIButton *)btn {
    self.touchBllock(btn.tag);
        
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _showImage.frame = _cellFrame.showImageViewFrame;
    _origin.frame = _cellFrame.origLableFrame;
    _origPrice.frame = _cellFrame.origPriceLableFrame;
    _pre.frame = _cellFrame.preLableFrame;
    _prefPrice.frame = _cellFrame.prePriceLableFrame;
    _goodsTitle.frame = _cellFrame.titelLableFrame;
    _favoritBtn.frame = _cellFrame.favoritButtonFrame;
    
    _touchBtn.frame = CGRectMake(0, 0, _cellFrame.cellSize.width, _cellFrame.cellSize.height);
    //添加手势用于退出键盘
    WeakSelf
    UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) { }];
    [self.contentView addGestureRecognizer:tap];
    
    
   // _cellSize = CGSizeMake((kScreen_Width - 3*5)/2, CGRectGetMaxY(_prefPrice.frame));

    //    [self.imageBackView showPlaceHolderWithAllSubviews];
}

- (UIButton *)touchBtn
{
    if (!_touchBtn) {
        _touchBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _touchBtn.userInteractionEnabled = YES;
    }
    return _touchBtn;
}

- (UIImageView *)showImage
{
    if (!_showImage) {
        _showImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _showImage.userInteractionEnabled = NO;
        //        _avatarImageView.backgroundColor = RandomColor;
    }
    return _showImage;
}


- (UILabel *)pre {
    if (!_pre) {
        _pre = [[UILabel alloc] initWithFrame:CGRectZero];
        _pre.layer.cornerRadius = 4;
        _pre.textAlignment = NSTextAlignmentCenter;
        _pre.layer.masksToBounds = YES;
        _pre.font = [UIFont systemFontOfSize:11];
    }
    return _pre;
}

- (UILabel *)prefPrice
{
    if (!_prefPrice) {
        
        _prefPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        _prefPrice.font = [UIFont systemFontOfSize:15];
        _prefPrice.backgroundColor = [UIColor redColor];
        _prefPrice.textColor = [UIColor colorWithRed:0.600 green:0.502 blue:0.900 alpha:1];
        
        // 1A1A1A
        //        _nickNameLable.backgroundColor = RandomColor;
    }
    return _prefPrice;
}

- (UILabel *)origin
{
    if (!_origin) {
        _origin = [[UILabel alloc] initWithFrame:CGRectZero];
        _origin.font = [UIFont systemFontOfSize:11];
    }
    return _origin;
}

- (UILabel *)origPrice
{
    if (!_prefPrice) {
        _prefPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        _prefPrice.font = [UIFont systemFontOfSize:11];
    }
    return _prefPrice;
}

- (UILabel *)goodsTitle
{
    if (!_goodsTitle) {
        _goodsTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsTitle.font = [UIFont systemFontOfSize:12];
        _goodsTitle.numberOfLines = 1;
        _goodsTitle.textColor = [UIColor lightGrayColor];
        //        _timeLable.backgroundColor = RandomColor;
    }
    return _goodsTitle;
}

/**
 *  cell的 收藏 按钮
 *
 *  @return button
 */
- (UIButton *)favoritBtn
{
    if (!_favoritBtn) {
        _favoritBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_favoritBtn addTarget:self action:@selector(favoritBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_favoritBtn setBackgroundImage:[UIImage imageNamed:@"u188"] forState:UIControlStateNormal];
        [_favoritBtn setBackgroundImage:[UIImage imageNamed:@"u188_selected"] forState:UIControlStateSelected];
        
    }
    return _favoritBtn;

}

- (void)favoritBtnAction {
    _favoritBtn.selected = !_favoritBtn.selected;
    
    if (self.btn) {
        self.btn(_favoritBtn);
    }
}

- (void)handleBUttonAction:(FavotitBtn)block {
    self.btn = block;
}

#pragma mark 手势
//block在HomeTableViewController中实现,加载
-(void)addTapDesBlock:(void(^)(HomeCollectionViewCell *cell))block
{
    _desTapBlock = block;
}

@end
