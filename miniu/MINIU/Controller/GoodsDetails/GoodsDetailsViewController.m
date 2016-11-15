//
//  GoodsDetailsViewController.m
//  miniu
//
//  Created by SimMan on 4/27/15.
//  Copyright (c) 2015 SimMan. All rights reserved.
//

#import "GoodsDetailsViewController.h"
//#import "GoodsDeailsCell.h"
//#import "HomeTableViewCellFrame.h"
//#import "HomeCollectionViewCell.h"
#import "HomeCollectionViewCellFrame.h"
#import "ApplyOrderViewController.h"
#import "SearchListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "OrderViewCell.h"
#import "UIImageView+WebImage.h"

#define TOOLBAR_HEIGHT 44.0f
#define LEFTVIEW_TAG    8001
#define FAVORITVIEW_TAG 8002
#define SHOPPINGCARVIEW_TAG 8003
#define RIGHTVIEW_TAG   8004

@interface GoodsDetailsViewController () //<HomeTableViewCellDelegate>
@property (nonatomic, strong) UIButton *chatButton;
@property (nonatomic, strong) UIButton *favoritButton;
@property (nonatomic, strong) UIButton *shopCarButton;
@property (nonatomic, strong) UIButton *buyButton;
@end

@implementation GoodsDetailsViewController
- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

//-(instancetype)initWithOrder:(OrderEntity *)order
//{
//
//    self = [super init];
//    if (self) {
//       // self.order = order;
//        //do some thing
//       // _cellFrame = [[HomeCollectionViewCellFrame alloc]initWithObject:[order transferToGoodsEntity]];
//    }
//    return self;
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.alpha = 0.3;

    self.navigationItem.backBarButtonItem = [UIBarButtonItem blankBarButton];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.contentSize = CGSizeMake(kScreen_Width, 1000);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.tag = 100;
    _scrollView.bounces = YES;
    [self.view addSubview:_scrollView];

    
    UIButton *carBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    carBtn.frame = CGRectMake(kScreen_Height-40, 10, 25, 25);
    [carBtn setBackgroundImage:[UIImage imageNamed:@"product_car_img_u362"] forState:UIControlStateNormal];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:carBtn];;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 100) {
        if (scrollView.contentOffset.y <= 0)
        {
            CGPoint offset = scrollView.contentOffset;
            offset.y = 0;
            scrollView.contentOffset = offset;
        }
    }
   
}




- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self setToolbarView];
    
    [self setImgPlyer];
    
    [self setCustView];

    
#if TARGET_IS_MINIU_BUYER
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
#else
    if(!_order){
        [self setToolbarView];
        
        [self setImgPlyer];
        
        [self setCustView];
        
        [self.navigationController setToolbarHidden:NO animated:NO];
        [self.navigationController chatToolBarHidden];
    }
#endif
}

//- (void)setGoodsEntity:(GoodsEntity *)goodsEntity
//{
//    _goodsEntity = _cellFrame.goodsEntity;
//}


- (void)setImgPlyer {
    _imgPlyer = [[UIScrollView alloc] init];
    _imgPlyer.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Width);
    _imgPlyer.pagingEnabled = YES;
    _imgPlyer.delegate = self;
    _imgPlyer.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    _control = [[UIPageControl alloc] init];
    _control.frame = CGRectMake(0, CGRectGetMaxY(_imgPlyer.frame)-20, kScreen_Width, 20);
    _control.currentPage = 0;
    _control.numberOfPages = _goodsEntity.goodsImagesCount;
    _control.backgroundColor = [UIColor clearColor];
    // [_control addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventValueChanged];
    NSArray *array = _goodsEntity.goodsImagesArray;
    
    if (array.count == 1)
    {
        NSString *str = [NSString stringWithFormat:@"%@",array.firstObject];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:_imgPlyer.frame];
        NSURL *url = [NSURL URLWithString:str];
        [_imgPlyer addSubview:imgView];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            imgView.image = [self cutImage:image];;
        }];
    }
    else
    {
        //设置偏移量，第一个imgView放最后一张图片,最后一个imgView放第一张图片,从第二个imgView开始显示,显示第一张图片
        _imgPlyer.contentOffset = CGPointMake(kScreen_Width, 0);
        _imgPlyer.contentSize = CGSizeMake(kScreen_Width * (array.count + 2) , kScreen_Width);
        
        UIImageView *imageViewLast = [[UIImageView alloc]initWithFrame:_imgPlyer.frame];
        NSString *str = [NSString stringWithFormat:@"%@",array.lastObject];
        NSURL *url = [NSURL URLWithString:str];
        [_imgPlyer addSubview:imageViewLast];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            imageViewLast.image = [self cutImage:image];;
        }];
        
        for (int i = 0; i<array.count; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(_imgPlyer.bounds.size.width*(i+1), 0, _imgPlyer.bounds.size.width, _imgPlyer.bounds.size.height)];
            [_imgPlyer addSubview:imgView];
            NSString *str = [NSString stringWithFormat:@"%@",array[i]];
            NSURL *url = [NSURL URLWithString:str];
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                imgView.image = [self cutImage:image];;
            }];
        }
        
        UIImageView *imageViewFirst= [[UIImageView alloc]initWithFrame:CGRectMake(_imgPlyer.bounds.size.width*(array.count + 1), 0, _imgPlyer.bounds.size.width, _imgPlyer.bounds.size.height)];
        NSString *strFirstr = [NSString stringWithFormat:@"%@",array.firstObject];
        NSURL *urlFirst = [NSURL URLWithString:strFirstr];
        [_imgPlyer addSubview:imageViewFirst];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:urlFirst options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            imageViewFirst.image = [self cutImage:image];
        }];

    }
    _imgPlyer.showsHorizontalScrollIndicator = NO;
    _imgPlyer.showsVerticalScrollIndicator = NO;
    
    [_scrollView addSubview:_imgPlyer];
    [_scrollView addSubview:_control];
}

- (UIImage *)cutImage:(UIImage*)image
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (kScreen_Width / kScreen_Width)) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * kScreen_Width / kScreen_Width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * kScreen_Width / kScreen_Width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    
    return [UIImage imageWithCGImage:imageRef];
}



- (void)setCustView {
    _custView = [[UIView alloc] init];
    [_scrollView addSubview:_custView];
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, kScreen_Width - 20, 40)];
   // titleLable.text = _goodsEntity.goodsTags;
    titleLable.text = _goodsEntity.depictRemark;
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = [UIColor lightGrayColor];
    titleLable.font = [UIFont systemFontOfSize:20];
    [_custView addSubview:titleLable];
    
    UILabel *originLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLable.frame)+5, kScreen_Width, 15)];
    originLable.textColor = [UIColor lightGrayColor];
    originLable.textAlignment = NSTextAlignmentCenter;
    originLable.font = [UIFont systemFontOfSize:12];
    originLable.text = [NSString stringWithFormat:@"专柜价:%@",@"暂无专柜价"];
    //[_custView addSubview:originLable];
    
    UILabel *priceLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(originLable.frame), kScreen_Width, 35)];
    UILabel *miLable = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width/2 - 60, 5, 45, 25)];
    miLable.backgroundColor = [UIColor colorWithRed:0.600 green:0.502 blue:0.900 alpha:1];
    miLable.layer.cornerRadius = 6;
    miLable.layer.masksToBounds = YES;
    miLable.text = @"米价:";
    miLable.textAlignment = NSTextAlignmentCenter;
    miLable.textColor = [UIColor whiteColor];
    miLable.font = [UIFont boldSystemFontOfSize:16];
    [priceLable addSubview:miLable];
    
    //= [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(miLable.frame)+7, 3, 80, 30)];
    UILabel *miPriceLable = [[UILabel alloc] init];
    CGFloat x = CGRectGetMaxX(miLable.frame);
    CGSize size = CGSizeMake(320,2000);
    CGFloat y = 3;
    CGSize lablesize;
    if (_goodsEntity.isShowPrice) {
        miPriceLable.text = [NSString stringWithFormat:@"￥%@",_goodsEntity.price];
        lablesize  = [[NSString stringWithFormat:@"%@",miPriceLable.text] sizeWithFont:[UIFont systemFontOfSize:40] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        miPriceLable.font = [UIFont systemFontOfSize:20];
    }else {
        lablesize = [@" 询价请私信" sizeWithFont:[UIFont systemFontOfSize:36] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        miPriceLable.font = [UIFont systemFontOfSize:18];
        miPriceLable.text = @" 询价请私信";
    }
    CGFloat width = lablesize.width;
    CGFloat heigh = lablesize.height;
    miPriceLable.frame = CGRectMake(x, y, width, 30);
    miPriceLable.backgroundColor = [UIColor clearColor];
    miPriceLable.textColor = [UIColor colorWithRed:0.600 green:0.502 blue:0.900 alpha:1];

    [priceLable addSubview:miPriceLable];
    
    UILabel *yuPriceLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(miPriceLable.frame), 3, 150, 30)];
    yuPriceLable.backgroundColor = [UIColor clearColor];
    yuPriceLable.font = [UIFont systemFontOfSize:14];
    yuPriceLable.textColor = [UIColor grayColor];
    yuPriceLable.text = [NSString stringWithFormat:@"预订价:%@",@"暂无"];
   // [priceLable addSubview:yuPriceLable];
    
    [_custView addSubview:priceLable];
   
    //[_custView addSubview:lable];
    
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(priceLable.frame)+20, kScreen_Width, kScreen_Width*72/750)];
//   // imgView.backgroundColor = [UIColor lightGrayColor];
//    imgView.image = [UIImage imageNamed:@"商品列表页_24.png"];
//    [_custView addSubview:imgView];
    
    UILabel *textLabel = [[UILabel alloc] init];
    NSString *str = _goodsEntity.depictRemark;
    CGSize contentSize = [_goodsEntity.depictRemark getSizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(kScreen_Width-30, CGFLOAT_MAX) andLineSpacing:3.5];
    CGFloat h = contentSize.height;
    textLabel.frame = CGRectMake(15, CGRectGetMaxY(priceLable.frame) + 5, kScreen_Width - 30, h);
    textLabel.text = str;
    textLabel.numberOfLines = 0;
   // textLabel.textAlignment = NSTextAlignmentTop;
    textLabel.textColor = [UIColor lightGrayColor];
    textLabel.font = [UIFont systemFontOfSize:15];
    [_custView addSubview:textLabel];
    
    _custView.frame = CGRectMake(0, kScreen_Width, kScreen_Width, CGRectGetMaxY(textLabel.frame));
    [_scrollView addSubview:_custView];
    _scrollView.contentSize = CGSizeMake(kScreen_Width, kScreen_Width + CGRectGetMaxY(textLabel.frame) + TOOLBAR_HEIGHT + 70);

}

- (void) setToolbarView
{
    CGFloat xpos = (kScreen_Width*0.25 - (39/36.0) * (TOOLBAR_HEIGHT - 6))/2;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width*0.25, TOOLBAR_HEIGHT)];
    leftView.backgroundColor = [UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1];
    leftView.tag = LEFTVIEW_TAG;
    _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _chatButton.frame = CGRectMake(xpos, 3, (39/36.0) * (TOOLBAR_HEIGHT - 6), TOOLBAR_HEIGHT - 6);
    [_chatButton setImage:[UIImage imageNamed:@"未标题-2_4"] forState:UIControlStateNormal];//78 72
//    _chatButton.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 12);
    [_chatButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:_chatButton];
    
    UIView *favoritView = [[UIView alloc] initWithFrame:CGRectMake(leftView.selfW, 0, kScreen_Width*0.25, TOOLBAR_HEIGHT)];
    favoritView.backgroundColor = [UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1];
    favoritView.tag = FAVORITVIEW_TAG;
    _favoritButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _favoritButton.frame = CGRectMake(xpos, 3, (39/36.0) * (TOOLBAR_HEIGHT - 6), TOOLBAR_HEIGHT - 6);
    [_favoritButton setImage:[UIImage imageNamed:@"未标题-1" ] forState:UIControlStateNormal];//78 72
    [_favoritButton setImage:[UIImage imageNamed:@"未标题-1_2" ] forState:UIControlStateSelected];
//    _favoritButton.imageEdgeInsets = UIEdgeInsetsMake(0, 13, 0, 13);
    [_favoritButton addTarget:self action:@selector(favoriteButtonActionobject:) forControlEvents:UIControlEventTouchUpInside];
    [favoritView addSubview:_favoritButton];
    
    UIView *shopCarView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(favoritView.frame), 0, kScreen_Width * 0.3, TOOLBAR_HEIGHT)];
    //shopCarView.backgroundColor = [UIColor blueColor];
    shopCarView.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.945 alpha:1];    shopCarView.tag = SHOPPINGCARVIEW_TAG;
    _shopCarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shopCarButton.frame = CGRectMake(0, 0, shopCarView.frame.size.width, TOOLBAR_HEIGHT);
    [_shopCarButton addTarget:self action:@selector(shopCarButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    UIEdgeInsets titleEdgeInset = _shopCarButton.titleEdgeInsets;
//    titleEdgeInset.left = 10;
//    _shopCarButton.titleEdgeInsets = titleEdgeInset;
    _buyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_shopCarButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    [_shopCarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _shopCarButton.titleLabel.font = [UIFont systemFontOfSize:15];
    //[shopCarView addSubview:_shopCarButton];
    
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(favoritView.frame), 0, kScreen_Width * 0.5, TOOLBAR_HEIGHT)];
    rightView.backgroundColor = [UIColor greenColor];
    rightView.tag = RIGHTVIEW_TAG;
    rightView.backgroundColor = [UIColor colorWithRed:0.600 green:0.502 blue:0.900 alpha:1];
    _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyButton.frame = CGRectMake(0, 0, rightView.frame.size.width, TOOLBAR_HEIGHT);
    [_buyButton addTarget:self action:@selector(buyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    //UIEdgeInsets titleEdgeInsets = _buyButton.titleEdgeInsets;
    //titleEdgeInsets.left = 10;
    _buyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    //_buyButton.titleEdgeInsets = titleEdgeInsets;
    [_buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _buyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightView addSubview:_buyButton];
    
    [self.navigationController.toolbar addSubview:leftView];
    [self.navigationController.toolbar addSubview:favoritView];
    [self.navigationController.toolbar addSubview:shopCarView];
    [self.navigationController.toolbar addSubview:rightView];
}

//联系客服
- (void) sendMessage
{
    [[self mainDelegate] changeToChatView];
}
//加入购物车(购物车还未实现)
- (void)shopCarButtonAction
{
    NSLog(@"加入购物车");
}

//收藏按钮
- (void)favoriteButtonActionobject:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (_goodsEntity.isMyLike) {
        [[logicShareInstance getGoodsManager] delCollectGoodsWithGoodsId:_goodsEntity.goodsId success:^(id responseObject) {} failure:^(NSString *error) {}];
        [self showStatusBarSuccessStr:@"取消收藏成功!"];
    } else {
        [[logicShareInstance getGoodsManager] addCollectGoodsWithGoodsId:_goodsEntity.goodsId success:^(id responseObject) {} failure:^(NSString *error) {}];
        [self showStatusBarSuccessStr:@"添加收藏成功!"];
    }
    
    if (_goodsEntity.isMyLike) {
        self.goodsEntity.likesCount --;
    } else {
        self.goodsEntity.likesCount ++;
    }
    self.goodsEntity.isMyLike = !self.goodsEntity.isMyLike;
}

//购买
- (void) buyButtonAction
{
    ApplyOrderViewController *appleyOrderVC = [[ApplyOrderViewController alloc] init];
    appleyOrderVC.goodsId = _goodsEntity.goodsId;
    [self.navigationController pushViewController:appleyOrderVC animated:YES];
}

#pragma mark-----点击分页控制符控制切换图片
-(void)pageAction:(UIPageControl *)pageControl{
    NSInteger page = pageControl.currentPage;
    
    _imgPlyer.contentOffset = CGPointMake(_imgPlyer.bounds.size.width*(page+1), 0);
    if (page == 0) {
        
    }
}

#pragma mark-----滑动切换图片
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollV {
    
    if (scrollV == _imgPlyer) {
        CGFloat offSetX = scrollV.contentOffset.x;
        NSInteger currentPage = offSetX/_imgPlyer.bounds.size.width;
        //    pageCon.currentPage = currentPage;
        
        if (currentPage == _goodsEntity.goodsImagesCount + 1) {
            scrollV.contentOffset = CGPointMake(kScreen_Width, 0);
            _control.currentPage = 0;
        }else if (currentPage == 0){
            scrollV.contentOffset = CGPointMake(kScreen_Width*_goodsEntity.goodsImagesCount, 0);
            _control.currentPage = 4;
        }else{
            _control.currentPage = currentPage-1;
        }
    }
    
}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
#if TARGET_IS_MINIU
    for (UIView *view in self.navigationController.toolbar.subviews) {
        if (view.tag == LEFTVIEW_TAG || view.tag == FAVORITVIEW_TAG || view.tag == SHOPPINGCARVIEW_TAG || view.tag == RIGHTVIEW_TAG ) {
            [view removeFromSuperview];
        }
    }
    [self.navigationController setToolbarHidden:YES animated:NO];
    [self.navigationController chatToolBarShow];
#endif
}

#pragma mark 网络获取
- (void) netWrokRequest
{
    WeakSelf
    [self.currentRequest addObject:[[logicShareInstance getGoodsManager] goodsDetailWithGoodsId:_goodsId currentPage:0 pageSize:0 success:^(id responseObject) {
        
        @try {
            GoodsEntity *goods = [[GoodsEntity alloc] init];
            [goods setValuesForKeysWithDictionary:responseObject[@"data"]];
            
//            HomeCollectionViewCellFrame *cellFrame = [[HomeCollectionViewCellFrame alloc] initWithObject:goods];
//            
//            weakSelf_SC.cellFrame = cellFrame;
//              [_imgPlyer reloadData];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            [weakSelf_SC.view endLoading];
           // [weakSelf_SC.view configBlankPage:EaseBlankPageTypeCollect hasData:_cellFrame ? YES : NO hasError:NO reloadButtonBlock:nil];
        };
        
        
    } failure:^(NSString *error) {
        [weakSelf_SC.view endLoading];
        [weakSelf_SC.view configBlankPage:EaseBlankPageTypeCollect hasData:NO hasError:YES reloadButtonBlock:^(id sender) {
            [weakSelf_SC netWrokRequest];
        }];
    }]];
}

#pragma mark - timer
- (void)countDown {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_MSEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        //...
    });
}
@end
