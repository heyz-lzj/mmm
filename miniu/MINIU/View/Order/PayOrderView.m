//
//  PayOrderView.m
//  miniu
//
//  Created by SimMan on 15/6/5.
//  Copyright (c) 2015年 SimMan. All rights reserved.
//

#import "PayOrderView.h"
#import "OrderEntity.h"
#import "FUIAlertView.h"
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
        
        self.priceLable = [[UILabel alloc] initWithFrame:CGRectMake(0, _topTipLable.selfMaxY + 20, kScreen_Width, 24)];
        [self.priceLable setTextAlignment:NSTextAlignmentCenter];
        [self.priceLable setFont:[UIFont systemFontOfSize:18]];

        self.taxLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _priceLable.selfMaxY + 10, kScreen_Width, 20)];
        [self.taxLabel setTextAlignment:NSTextAlignmentCenter];
        [self.taxLabel setFont:[UIFont systemFontOfSize:14]];
        self.taxLabel.textColor = [UIColor colorWithHexString:@"333333"];
        
        self.totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _taxLabel.selfMaxY + 10, kScreen_Width, 20)];
        [self.totalLabel setTextAlignment:NSTextAlignmentCenter];
        [self.totalLabel setFont:[UIFont systemFontOfSize:14]];
        self.totalLabel.textColor = [UIColor colorWithRed:219/255.0 green:16/255.0 blue:94/255.0 alpha:1];

        
        self.taxDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, _totalLabel.selfMaxY + 10, kScreen_Width-60, 20)];
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
    [self.findViewController showHudSuccess:@"到手价=商品成交价格+税费+运费\n中国海关规定进口商品需要缴纳进口税，每个商品因类目不同，有不同的税率。\n进口税=商品完税X税率，完税价格由海关最终认定"];
    FUIAlertView *alert = [[FUIAlertView alloc]initWithTitle:@"总价规则" message:@"到手价=商品成交价格+税费+运费\n中国海关规定进口商品需要缴纳进口税，每个商品因类目不同，有不同的税率。\n进口税=商品完税X税率，完税价格由海关最终认定" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    alert.backgroundColor = [UIColor clearColor];
    [alert show];
    
    
}
@end
