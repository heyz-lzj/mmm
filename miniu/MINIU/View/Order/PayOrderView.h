//
//  PayOrderView.h
//  miniu
//
//  Created by SimMan on 15/6/5.
//  Copyright (c) 2015年 SimMan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  支付类型
 */
typedef NS_ENUM(NSInteger, payButtonTag){
    /**
     *  订金
     */
    payButtonTagWithWechatPay = 100,
    /**
     *  定金
     */
    payButtonTagWithAlipay,
    /**
     *  全款
     */
    payButtonTagWithBank
};

@class OrderEntity;

@protocol PayOrderViewDelegate <NSObject>
- (void) payButtonDidClick:(payButtonTag)payButtonTag;
@end

@interface PayOrderView : UIView

@property (nonatomic, assign) id <PayOrderViewDelegate> delegate;
@property (nonatomic, strong) OrderEntity *order;

@end


@interface CKAlertAction : NSObject

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(CKAlertAction *action))handler;

@property (nonatomic, readonly) NSString *title;

@end


@interface CKAlertViewController : UIViewController

@property (nonatomic, readonly) NSArray<CKAlertAction *> *actions;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSTextAlignment messageAlignment;

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message;
- (void)addAction:(CKAlertAction *)action;

@end
