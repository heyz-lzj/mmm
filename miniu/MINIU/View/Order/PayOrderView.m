//
//  PayOrderView.m
//  miniu
//
//  Created by SimMan on 15/6/5.
//  Copyright (c) 2015年 SimMan. All rights reserved.
//

#import "PayOrderView.h"
#import "OrderEntity.h"
//#import "SIAlertView.h"
@interface PayOrderView()

@property (nonatomic, strong) UILabel *topTipLable;         // 提示信息
@property (nonatomic, strong) UILabel *priceLable;          // 价格

@property (nonatomic, strong) UILabel *taxLabel;            //税
@property (nonatomic, strong) UILabel *totalLabel;          //到手价
@property (nonatomic, strong) UILabel *taxDescLabel;        //价格解释文本

@property (nonatomic, strong) FUIButton *wxpayButton;       //微信支付按钮
@property (nonatomic, strong) UILabel *chooseOtherPayment;  //选择其他支付按钮
@property (nonatomic, strong) UIButton *alipayButton;       // 支付宝支付按钮
@property (nonatomic, strong) UIButton *bankCardPayButton;  //银行卡支付按钮

@end

@implementation PayOrderView

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        WeakSelf
        self.topTipLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, kScreen_Width, 18)];
        [self.topTipLable setTextColor:[UIColor colorWithRed:0.439 green:0.439 blue:0.439 alpha:1]];
        [self.topTipLable setFont:[UIFont systemFontOfSize:18]];
        [self.topTipLable setTextAlignment:NSTextAlignmentCenter];
        [self.topTipLable setText:@"代购订单已生成,请尽快支付噢"];
        
        self.priceLable = [[UILabel alloc] initWithFrame:CGRectMake(0, _topTipLable.selfMaxY + 20, kScreen_Width, 26)];
        [self.priceLable setTextAlignment:NSTextAlignmentCenter];
        [self.priceLable setFont:[UIFont systemFontOfSize:30]];

        self.taxLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _priceLable.selfMaxY + 20, kScreen_Width/2, 20)];
        [self.taxLabel setTextAlignment:NSTextAlignmentCenter];
        [self.taxLabel setFont:[UIFont systemFontOfSize:14]];
        self.taxLabel.textColor = [UIColor colorWithHexString:@"333333"];
        
        self.totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width/2, _priceLable.selfMaxY + 20, kScreen_Width/2, 20)];
        [self.totalLabel setTextAlignment:NSTextAlignmentCenter];
        [self.totalLabel setFont:[UIFont systemFontOfSize:14]];
        self.totalLabel.textColor = [UIColor colorWithRed:219/255.0 green:16/255.0 blue:94/255.0 alpha:1];

        
        self.taxDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, _totalLabel.selfMaxY + 15, kScreen_Width-60, 20)];
        [self.taxDescLabel setFont:[UIFont systemFontOfSize:12]];
        [self.taxDescLabel setTextAlignment:NSTextAlignmentCenter];
        self.taxDescLabel.numberOfLines = 1;
        self.taxDescLabel.textColor = [UIColor colorWithHexString:@"929292"];
        self.taxDescLabel.text = @"总价规则";
        self.taxDescLabel.userInteractionEnabled = YES;
//        self.taxDescLabel.text = @"到手价=商品成交价格+税费+运费\n中国海关规定进口商品需要缴纳进口税，每个商品因类目不同，有不同的税率。\n进口税=商品完税X税率，完税价格由海关最终认定";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToShowTaxDescreaption:)];
        [self.taxDescLabel addGestureRecognizer:tap];

        
        self.wxpayButton = [[FUIButton alloc] initWithFrame:CGRectMake(50, _taxDescLabel.selfMaxY + 20, kScreen_Width - 100, 43)];//100->20
        [self.wxpayButton setTitle:@"微信支付" forState:UIControlStateNormal];
        [self.wxpayButton setButtonColor:[UIColor colorWithRed:0.325 green:0.843 blue:0.412 alpha:1]];
        self.wxpayButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
        [self.wxpayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.wxpayButton.cornerRadius = 5;
        [self.wxpayButton bk_addEventHandler:^(id sender) {
            //
            if (weakSelf_SC.delegate && [weakSelf_SC.delegate respondsToSelector:@selector(payButtonDidClick:)]) {
                [weakSelf_SC.delegate payButtonDidClick:payButtonTagWithWechatPay];
            }
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        self.chooseOtherPayment = [[UILabel alloc] initWithFrame:CGRectMake(0, _wxpayButton.selfMaxY + 20, kScreen_Width, 18)];
        [self.chooseOtherPayment setTextColor:[UIColor colorWithRed:0.627 green:0.627 blue:0.627 alpha:1]];
        [self.chooseOtherPayment setFont:[UIFont systemFontOfSize:11]];
        [self.chooseOtherPayment setTextAlignment:NSTextAlignmentCenter];
        [self.chooseOtherPayment setText:@"选择其他付款方式"];
        
        self.alipayButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _chooseOtherPayment.selfMaxY + 20, kScreen_Width, 16)];
        [self.alipayButton setTitle:@"支付宝" forState:UIControlStateNormal];
        [self.alipayButton setTitleColor:[UIColor colorWithRed:0.310 green:0.847 blue:0.408 alpha:1] forState:UIControlStateNormal];
        [self.alipayButton bk_addEventHandler:^(id sender) {
            if (weakSelf_SC.delegate && [weakSelf_SC.delegate respondsToSelector:@selector(payButtonDidClick:)]) {
                [weakSelf_SC.delegate payButtonDidClick:payButtonTagWithAlipay];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        self.bankCardPayButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _alipayButton.selfMaxY + 20, kScreen_Width, 16)];
        [self.bankCardPayButton setTitle:@"银行卡支付" forState:UIControlStateNormal];
        [self.bankCardPayButton setTitleColor:[UIColor colorWithRed:0.310 green:0.847 blue:0.408 alpha:1] forState:UIControlStateNormal];
        [self.bankCardPayButton bk_addEventHandler:^(id sender) {
            if (weakSelf_SC.delegate && [weakSelf_SC.delegate respondsToSelector:@selector(payButtonDidClick:)]) {
                [weakSelf_SC.delegate payButtonDidClick:payButtonTagWithBank];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_topTipLable];
        [self addSubview:_priceLable];
        [self addSubview:_taxLabel];
        [self addSubview:_totalLabel];
        [self addSubview:_taxDescLabel];
        [self addSubview:_wxpayButton];
        [self addSubview:_chooseOtherPayment];
        [self addSubview:_alipayButton];
        [self addSubview:_bankCardPayButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, 175, kScreen_Width, _bankCardPayButton.selfMaxY + 20);
    
    
#if TARGET_IS_MINIU_BUYER
    [self.wxpayButton setEnabled:NO];
    [self.chooseOtherPayment setEnabled:NO];
    [self.alipayButton setEnabled:NO];
    [self.bankCardPayButton setEnabled:NO];
#endif
    
}

- (void)setOrder:(OrderEntity *)order
{
    _order = order;
    
    // 如果定金大于0并且订单状态为未支付则进行定金支付
    if (order.totalBailAmount > 0 && order.orderStatus == orderStatusOfWaitPayment) {
        [self.priceLable setText:[NSString stringWithFormat:@"定金：￥%0.2f", order.totalBailAmount]];
        // 否则为支付全款
    } else {
        [self.priceLable setText:[NSString stringWithFormat:@"金额：￥%0.2f", order.totalAmount]];
    }
    
    //新需求 2016.11.11 需要显示进口税价格
    if(order.totalAmount > order.price.integerValue){
        //如果后台返回数据是带有税的
        [self.priceLable setText:[NSString stringWithFormat:@"商品金额：￥%0.2f", order.price.floatValue]];
        
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"预计进口税：￥%0.2f",0.119*order.price.floatValue]];
//        NSRange contentRange = {0,[content length]};
//        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        self.taxLabel.attributedText = content;
        self.totalLabel.text = [NSString stringWithFormat:@"到手价：￥%0.2f",order.totalAmount];
        
    }else{
        //前台计算
        [self.priceLable setText:[NSString stringWithFormat:@"商品金额：￥%0.2f", order.price.floatValue]];
        
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"预计进口税：￥%0.2f",0.119*order.price.floatValue]];
//        NSRange contentRange = {0,[content length]};
//        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        self.taxLabel.attributedText = content;
//        self.taxLabel.text = [NSString stringWithFormat:@"进口税：预计 ￥%0.2f",0.119*order.price.floatValue];
        self.totalLabel.text = [NSString stringWithFormat:@"到手价：￥%0.2f",1.119*order.price.floatValue];

    }
}


- (void)tapToShowTaxDescreaption:(UITapGestureRecognizer *)tap{
//    [self.findViewController showHudSuccess:@"到手价=商品成交价格+税费+运费\n中国海关规定进口商品需要缴纳进口税，每个商品因类目不同，有不同的税率。\n进口税=商品完税X税率，完税价格由海关最终认定"];
//    SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"总价规则" andMessage:@"到手价=商品成交价格+税费+运费\n中国海关规定进口商品需要缴纳进口税，每个商品因类目不同，有不同的税率。\n进口税=商品完税X税率，完税价格由海关最终认定"];
    
//    [alert show];
    
    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"总价规则" message:@"到手价=商品成交价格+税费+运费。\n\n中国海关规定进口商品需要缴纳进口税，每个商品因类目不同，有不同的税率。\n\n进口税=商品完税X税率，完税价格由海关最终认定。" ];
    alertVC.messageAlignment = NSTextAlignmentLeft;
    
    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"好的" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
    }];

    
    [alertVC addAction:cancel];
    
    
    [self.findViewController presentViewController:alertVC animated:NO completion:nil];
    
    
}
@end

@interface SFHighLightButton : UIButton

@property (strong, nonatomic) UIColor *highlightedColor;

@end

@implementation SFHighLightButton

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = self.highlightedColor;
    }
    else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.backgroundColor = nil;
        });
    }
}

@end

#define kThemeColor [UIColor colorWithRed:94/255.0 green:96/255.0 blue:102/255.0 alpha:1]

@interface CKAlertAction ()

@property (copy, nonatomic) void(^actionHandler)(CKAlertAction *action);

@end

@implementation CKAlertAction

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(CKAlertAction *action))handler {
    CKAlertAction *instance = [CKAlertAction new];
    instance -> _title = title;
    instance.actionHandler = handler;
    return instance;
}

@end


@interface CKAlertViewController ()
{
    UIView *_shadowView;
    UIView *_contentView;
    
    UIEdgeInsets _contentMargin;
    CGFloat _contentViewWidth;
    CGFloat _buttonHeight;
    
    BOOL _firstDisplay;
}

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) NSMutableArray *mutableActions;
@end

@implementation CKAlertViewController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message {
    
    CKAlertViewController *instance = [CKAlertViewController new];
    instance.title = title;
    instance.message = message;
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        [self defaultSetting];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建对话框
    [self creatShadowView];
    [self creatContentView];
    
    [self creatAllButtons];
    [self creatAllSeparatorLine];
    
    self.titleLabel.text = self.title;
    self.messageLabel.text = self.message;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    //更新标题的frame
    [self updateTitleLabelFrame];
    
    //更新message的frame
    [self updateMessageLabelFrame];
    
    //更新按钮的frame
    [self updateAllButtonsFrame];
    
    //更新分割线的frame
    [self updateAllSeparatorLineFrame];
    
    //更新弹出框的frame
    [self updateShadowAndContentViewFrame];
    
    //显示弹出动画
    [self showAppearAnimation];
}

- (void)defaultSetting {
    
    _contentMargin = UIEdgeInsetsMake(25, 20, 0, 20);
    _contentViewWidth = 285;
    _buttonHeight = 45;
    _firstDisplay = YES;
    _messageAlignment = NSTextAlignmentCenter;
}

#pragma mark - 创建内部视图

//阴影层
- (void)creatShadowView {
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentViewWidth, 175)];
    _shadowView.layer.masksToBounds = NO;
    _shadowView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25].CGColor;
    _shadowView.layer.shadowRadius = 20;
    _shadowView.layer.shadowOpacity = 1;
    _shadowView.layer.shadowOffset = CGSizeMake(0, 10);
    [self.view addSubview:_shadowView];
}

//内容层
- (void)creatContentView {
    _contentView = [[UIView alloc] initWithFrame:_shadowView.bounds];
    _contentView.backgroundColor = [UIColor colorWithRed:250 green:251 blue:252 alpha:1];
    _contentView.layer.cornerRadius = 13;
    _contentView.clipsToBounds = YES;
    [_shadowView addSubview:_contentView];
}

//创建所有按钮
- (void)creatAllButtons {
    
    for (int i=0; i<self.actions.count; i++) {
        
        SFHighLightButton *btn = [SFHighLightButton new];
        btn.tag = 10+i;
        btn.highlightedColor = [UIColor colorWithWhite:0.97 alpha:1];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:kThemeColor forState:UIControlStateNormal];
        [btn setTitle:self.actions[i].title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:btn];
    }
}

//创建所有的分割线
- (void)creatAllSeparatorLine {
    
    if (!self.actions.count) {
        return;
    }
    
    //要创建的分割线条数
    NSInteger linesAmount = self.actions.count>2 ? self.actions.count : 1;
    linesAmount -= (self.title.length || self.message.length) ? 0 : 1;
    
    for (int i=0; i<linesAmount; i++) {
        
        UIView *separatorLine = [UIView new];
        separatorLine.tag = 1000+i;
        separatorLine.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
        [_contentView addSubview:separatorLine];
    }
}

- (void)updateTitleLabelFrame {
    
    CGFloat labelWidth = _contentViewWidth - _contentMargin.left - _contentMargin.right;
    CGFloat titleHeight = 0.0;
    if (self.title.length) {
        CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(labelWidth, CGFLOAT_MAX)];
        titleHeight = size.height;
        self.titleLabel.frame = CGRectMake(_contentMargin.left, _contentMargin.top, labelWidth, size.height);
    }
}

- (void)updateMessageLabelFrame {
    
    CGFloat labelWidth = _contentViewWidth - _contentMargin.left - _contentMargin.right;
    //更新message的frame
    CGFloat messageHeight = 0.0;
    CGFloat messageY = self.title.length ? CGRectGetMaxY(_titleLabel.frame) + 20 : _contentMargin.top;
    if (self.message.length) {
        CGSize size = [self.messageLabel sizeThatFits:CGSizeMake(labelWidth, CGFLOAT_MAX)];
        messageHeight = size.height;
        self.messageLabel.frame = CGRectMake(_contentMargin.left, messageY, labelWidth, size.height);
    }
}

- (void)updateAllButtonsFrame {
    
    if (!self.actions.count) {
        return;
    }
    
    CGFloat firstButtonY = [self getFirstButtonY];
    
    CGFloat buttonWidth = self.actions.count>2 ? _contentViewWidth : _contentViewWidth/self.actions.count;
    
    for (int i=0; i<self.actions.count; i++) {
        UIButton *btn = [_contentView viewWithTag:10+i];
        CGFloat buttonX = self.actions.count>2 ? 0 : buttonWidth*i;
        CGFloat buttonY = self.actions.count>2 ? firstButtonY+_buttonHeight*i : firstButtonY;
        
        btn.frame = CGRectMake(buttonX, buttonY, buttonWidth, _buttonHeight);
    }
}

- (void)updateAllSeparatorLineFrame {
    
    //分割线的条数
    NSInteger linesAmount = self.actions.count>2 ? self.actions.count : 1;
    linesAmount -= (self.title.length || self.message.length) ? 0 : 1;
    NSInteger offsetAmount = (self.title.length || self.message.length) ? 0 : 1;
    for (int i=0; i<linesAmount; i++) {
        //获取到分割线
        UIView *separatorLine = [_contentView viewWithTag:1000+i];
        //获取到对应的按钮
        UIButton *btn = [_contentView viewWithTag:10+i+offsetAmount];
        
        CGFloat x = linesAmount==1 ? _contentMargin.left : btn.frame.origin.x;
        CGFloat y = btn.frame.origin.y;
        CGFloat width = linesAmount==1 ? _contentViewWidth - _contentMargin.left - _contentMargin.right : _contentViewWidth;
        separatorLine.frame = CGRectMake(x, y, width, 0.5);
    }
}

- (void)updateShadowAndContentViewFrame {
    
    CGFloat firstButtonY = [self getFirstButtonY];
    
    CGFloat allButtonHeight;
    if (!self.actions.count) {
        allButtonHeight = 0;
    }
    else if (self.actions.count<3) {
        allButtonHeight = _buttonHeight;
    }
    else {
        allButtonHeight = _buttonHeight*self.actions.count;
    }
    
    //更新警告框的frame
    CGRect frame = _shadowView.frame;
    frame.size.height = firstButtonY+allButtonHeight;
    _shadowView.frame = frame;
    
    _shadowView.center = self.view.center;
    _contentView.frame = _shadowView.bounds;
}

- (CGFloat)getFirstButtonY {
    
    CGFloat firstButtonY = 0.0;
    if (self.title.length) {
        firstButtonY = CGRectGetMaxY(self.titleLabel.frame);
    }
    if (self.message.length) {
        firstButtonY = CGRectGetMaxY(self.messageLabel.frame);
    }
    firstButtonY += firstButtonY>0 ? 15 : 0;
    return firstButtonY;
}

#pragma mark - 事件响应
- (void)didClickButton:(UIButton *)sender {
    CKAlertAction *action = self.actions[sender.tag-10];
    if (action.actionHandler) {
        action.actionHandler(action);
    }
    
    [self showDisappearAnimation];
}

#pragma mark - 其他方法

- (void)addAction:(CKAlertAction *)action {
    [self.mutableActions addObject:action];
}

- (UILabel *)creatLabelWithFontSize:(CGFloat)fontSize {
    
    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = kThemeColor;
    return label;
}

- (void)showAppearAnimation {
    
    if (_firstDisplay) {
        _firstDisplay = NO;
        _shadowView.alpha = 0;
        _shadowView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _shadowView.transform = CGAffineTransformIdentity;
            _shadowView.alpha = 1;
        } completion:nil];
    }
}

- (void)showDisappearAnimation {
    
    [UIView animateWithDuration:0.1 animations:^{
        _contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - getter & setter

- (NSString *)title {
    return [super title];
}

- (NSArray<CKAlertAction *> *)actions {
    return [NSArray arrayWithArray:self.mutableActions];
}

- (NSMutableArray *)mutableActions {
    if (!_mutableActions) {
        _mutableActions = [NSMutableArray array];
    }
    return _mutableActions;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [self creatLabelWithFontSize:16];
        _titleLabel.text = self.title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [self creatLabelWithFontSize:14];
        _messageLabel.text = self.message;
        _messageLabel.textAlignment = self.messageAlignment;
        [_contentView addSubview:_messageLabel];
    }
    return _messageLabel;
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    _titleLabel.text = title;
}

- (void)setMessage:(NSString *)message {
    _message = message;
    _messageLabel.text = message;
}

- (void)setMessageAlignment:(NSTextAlignment)messageAlignment {
    _messageAlignment = messageAlignment;
    _messageLabel.textAlignment = messageAlignment;
}

@end
