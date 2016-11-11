//
//  HomeViewController.m
//  miniu
//
//  Created by SimMan on 4/16/15.
//  Copyright (c) 2015 SimMan. All rights reserved.
//

#import "HomeViewController.h"
#import "BlocksKit.h"
//#import "HomeCollectionViewCell.h"
#import "GoodsEntity.h"
#import "SDWebImageManager.h"
//#import "ShowMenuView.h"
#import "ApplyOrderViewController.h"
#import "UserEntity.h"
#import "SearchViewController.h"
#import "ImagePlayerView.h"

#import "UIBarButtonItem+Badge.h"
#import "SearchListViewController.h"

#import "GoodsDetailsViewController.h"

#import "MBProgressHUD.h"

#import "UIImageView+WebCache.h"

//改瀑布流新增
#import "HomeCollectionViewCell.h"
#import "HomeCollectionViewCellFrame.h"
#import "MyLayout.h"

#if TARGET_IS_MINIU
@interface HomeViewController () <ImagePlayerViewDelegate, HomeCollectionViewCellDelegate> {
    CGFloat _oldPanOffsetY;
}
#else
@interface HomeViewController () <ImagePlayerViewDelegate, HomeCollectionViewCellDelegate>
#endif

#if TARGET_IS_MINIU
@property (nonatomic, strong) UIBarButtonItem *chatButtonItem;
#endif

@property (strong, nonatomic) ImagePlayerView *imagePlayerView;

@property (strong, nonatomic) MyLayout *myLayout;

@property (nonatomic, strong) NSMutableArray *adsData;


@end

@implementation HomeViewController {
    float AD_height;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _adsData = [NSMutableArray new];
        //[ShowMenuView shareInstance].delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    WeakSelf
    
    self.navigationItem.backBarButtonItem = [UIBarButtonItem blankBarButton];
    //导航栏右边的按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分类"] style:UIBarButtonItemStylePlain target:self action:@selector(pushSearchViewController)];
    //设置导航栏中间的图
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    UIButton *button = [[UIButton alloc] initWithFrame:titleView.frame];
   // button.backgroundColor = [UIColor redColor];
    [button setTitle:self.tagName forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button bk_addEventHandler:^(id sender) {
        [weakSelf_SC.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        //点击标题事件处理
        NSLog(@"click checked!");
    } forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:button];
    
    self.navigationItem.titleView = titleView;
    
    //注册cell和ReusableView(相当于头视图)
    AD_height = 150;//广告栏高度
    _myLayout = [[MyLayout alloc]init];
    //_myLayout.sectionInset = UIEdgeInsetsMake(0, 4, 5, 4);
    [_myLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _myLayout.headerReferenceSize = CGSizeMake(kScreen_Width, AD_height+10);
   // self.collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:_myLayout];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    //隐藏滚动条
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    //设置代理
    self.collectionView.delegate =self;
    self.collectionView.dataSource =self;
    
    //注册单元格
    [self.collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    //[self.collectionView registerClass:[HeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
   // [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];

    //广告栏
//    _headerView = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 200)];
//    _headerView.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:self.collectionView];
    
    [self setupRefresh];
    
    [self.view beginLoading];
    
    //[self loadData];
    
    //导航栏下方广告处理
//    [[logicShareInstance getADManager] refreshAdsWithTag:self.tagName block:^(NSArray *ads) {
//        if ([ads count]) {
//            [weakSelf_SC.adsData addObjectsFromArray:ads];
//            [self setUpAdView];
//        }
//    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
#if TARGET_IS_MINIU_BUYER
    //买家版隐藏tabbar
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
#endif
}

- (void) pushSearchViewController
{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.tagName = self.tagName;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
    //进入耗时阶段
    [super viewDidAppear:animated];
}

#pragma mark 上拉加载，下拉刷新
- (void)setupRefresh
{
    __weak __typeof(&*self)weakSelf_SC = self;
    [self addRefreshBlockWithHeader:^{
        weakSelf_SC.pageNum = 1;
        [weakSelf_SC netWorkRequestForGoodsListWithPage:weakSelf_SC.pageNum Type:LOAD_UPDATE];
    } AndFooter:^{
        weakSelf_SC.pageNum ++;
        [weakSelf_SC netWorkRequestForGoodsListWithPage:weakSelf_SC.pageNum Type:LOAD_MORE];
    } autoRefresh:YES];
}


#pragma -mark UICollectionView delegate

//设置cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeCollectionViewCellFrame *cellFrame = self.dataArray[indexPath.row];
    return cellFrame.cellSize;
}

#pragma -mark UICollectionView datasource
//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section

{
    return self.dataArray.count;
}

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"cell";
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[HomeCollectionViewCell alloc] init];
    }
    cell.tag = indexPath.row;
    
    HomeCollectionViewCellFrame *cellFrame = self.dataArray[indexPath.row];
    cell.cellFrame = cellFrame;
    
    cell.delegate = self;
    
    __weak typeof(self) weakself=self;
    
    cell.touchBllock = ^(NSInteger tag){
        typeof(self) this=weakself;
        
        GoodsDetailsViewController *goodsDetails = [[GoodsDetailsViewController alloc] init];
        goodsDetails.goodsEntity = cell.cellFrame.goodsEntity;
        
        
        [this.navigationController pushViewController:goodsDetails animated:YES];
    };
    
    
    [cell handleBUttonAction:^(UIButton *btn) {
        
        if (btn.selected) {
            [btn setBackgroundImage:[UIImage imageNamed:@"u188_selected"] forState:UIControlStateSelected];
        }else {
            [btn setBackgroundImage:[UIImage imageNamed:@"u188"] forState:UIControlStateNormal];
        }
        [self favoriteButtonAction:cell.goods.isMyLike object:cell];
        cell.goods.isMyLike = !cell.goods.isMyLike;
        
    }];
    
    return cell;
}


//#pragma mark 网络请求 商品列表
- (void)netWorkRequestForGoodsListWithPage:(NSInteger)pageNum Type:(LOAD_TYPE)type
{
    WeakSelf
    [[logicShareInstance getGoodsManager] getGoodsListWithTagName:[NSString stringWithFormat:@"%@", self.tagName] CurrentPage:pageNum pageSize:10 success:^(id responseObject) {

        @try {
            [self asyncBackgroundQueue:^{
                
                NSMutableArray *tmpDataArray = [NSMutableArray arrayWithCapacity:1];
                
                for (NSDictionary *dic in [responseObject objectForKey:@"data"]){
                    GoodsEntity *goods = [[GoodsEntity alloc] init];
                    [goods setValuesForKeysWithDictionary:dic];
                    
                    //获取数据时计算各种cell frame
                    HomeCollectionViewCellFrame *cellFrame = [[HomeCollectionViewCellFrame alloc] initWithObject:goods];
                    [tmpDataArray addObject:cellFrame];
                }
                
                if (type == LOAD_UPDATE) {
                    [weakSelf_SC.dataArray removeAllObjects];
                }
                
                if ([tmpDataArray count]) {
                    [weakSelf_SC.dataArray addObjectsFromArray:tmpDataArray];
                } else {
                    if (type == LOAD_MORE) {
                        weakSelf_SC.pageNum --;
                    }
                }
                //[weakSelf_SC.collectionView reloadData];
                [weakSelf_SC.view endLoading];

//                sleep(5);
                
                [weakSelf_SC asyncMainQueue:^{
                    if (![tmpDataArray count] && [self.dataArray count]) {
                        //[weakSelf_SC showStatusBarError:@"没有更多了!"];//据说太丑了 需要换成弹出的 然后提示
                        
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.mode = MBProgressHUDModeCustomView;// MBProgressHUDModeText;
                        hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_result_signed"]];
                        hud.labelText = @"没有更多内容啦!";
                        //hud..backgroundTintColor = [uic];
                        [hud hide:YES afterDelay:1];
                        
                    }
                    [weakSelf_SC.collectionView reloadData];
                }];
            }];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
        };
    } failure:^(NSString *error) {
        if (type == LOAD_MORE) {
            weakSelf_SC.pageNum --;
        }
        [weakSelf_SC.view endLoading];
        [weakSelf_SC showStatusBarError:error];
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    [SDWebImageManager.sharedManager.imageCache clearMemory];
}

#pragma mark showMenuViewDelegate

- (void) favoriteButtonAction:(BOOL)selected object:(HomeCollectionViewCell *)cell
{
    if (cell.cellFrame.goodsEntity.isMyLike) {
        [[logicShareInstance getGoodsManager] delCollectGoodsWithGoodsId:cell.cellFrame.goodsEntity.goodsId success:^(id responseObject) {} failure:^(NSString *error) {}];
        [self showStatusBarSuccessStr:@"取消收藏成功!"];
    } else {
        [[logicShareInstance getGoodsManager] addCollectGoodsWithGoodsId:cell.cellFrame.goodsEntity.goodsId success:^(id responseObject) {} failure:^(NSString *error) {}];
        [self showStatusBarSuccessStr:@"添加收藏成功!"];
    }
    
 
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    HomeCollectionViewCellFrame *cellFrame = self.dataArray[indexPath.row];
    cellFrame.goodsEntity.isMyLike = selected;
    
    if (selected) {
        cellFrame.goodsEntity.likesCount ++;
    } else {
        cellFrame.goodsEntity.likesCount --;
    }
    
    [self.dataArray replaceObjectAtIndex:indexPath.row withObject:cellFrame];
    
    //[self.collectionView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UICollectionViewRowAnimationAutomatic];
}

#pragma mark 幻灯片
- (void) setUpAdView
{
    if (!self.imagePlayerView) {
        self.imagePlayerView = [[ImagePlayerView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width / 2.37)];
        self.imagePlayerView.imagePlayerViewDelegate = self;
        
        // set auto scroll interval to x seconds
        self.imagePlayerView.scrollInterval = 4.0f;
        
        // adjust pageControl position
        self.imagePlayerView.pageControlPosition = ICPageControlPosition_BottomCenter;
        
        // hide pageControl or not
        self.imagePlayerView.hidePageControl = NO;
        
        // adjust edgeInset
        //    self.imagePlayerView.edgeInsets = UIEdgeInsetsMake(10, 20, 30, 40);
        //设置头部广告栏
        [self asyncMainQueue:^{
            //self.collectionView.tableHeaderView = self.imagePlayerView;
        }];
    }
   // [self.view addSubview:_imagePlayerView];
    [self.imagePlayerView reloadData];
}

#pragma mark - ImagePlayerViewDelegate
- (NSInteger)numberOfItems
{
    NSInteger count = [_adsData count];
    return count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    ADentity *adentity = [_adsData objectAtIndex:index];
    NSString *imageURL = [NSString stringWithFormat:@"%@", adentity.imageUrl];
    [imageView setImageWithUrl:imageURL withSize:ImageSizeOfNone];
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    ADentity *adentity = [_adsData objectAtIndex:index];
    //传递当前广告实体
    [logicShareInstance getADManager].currentADentity = adentity;
    [self openUrlOnWebViewWithURL:[NSURL URLWithString:adentity.linkedUrl] type:ADPUSH];
}

- (void)scrollWillUp
{
#if TARGET_IS_MINIU
    [self.navigationController setToolbarHidden:YES animated:YES];
#else
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
#endif
}

- (void) scrollWillDown
{
#if TARGET_IS_MINIU
    [self.navigationController setToolbarHidden:NO animated:YES];
#else
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
#endif
}

- (void)scrollWillScroll
{
    //[ShowMenuView hidden];
}


//#pragma mark - 懒加载
//- (NSMutableArray *)adsData {
//    if (_adsData == nil) {
//        _adsData = [NSMutableArray array];
//    }
//    return _adsData;
//}
//设置头视图高度
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    return CGSizeMake(kScreen_Width, AD_height);
//}
////头部现实的内容
//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
//    if (self.adsData == nil) {
//        ADentity *adentity = [_adsData objectAtIndex:indexPath.row];
//        //传递当前广告实体
//        [logicShareInstance getADManager].currentADentity = adentity;
//        [_headerView.headerImg setImage:[UIImage imageNamed:adentity.imageUrl]];
//        _headerView.tagNameLable.text = adentity.title;
//        _headerView.describeLable.text = adentity.depictRemark;
//        if (_headerView.describeLable.text) {
//            _headerView.describeLable.hidden = NO;
//        } else {
//            _headerView.describeLable.hidden = YES;
//
//        }
//    }
//
//    //设置头部广告栏
//    [headerView addSubview:_imagePlayerView];
//
//    return headerView;
//}
@end
