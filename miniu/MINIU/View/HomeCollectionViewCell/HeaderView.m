//
//  HeaderView.m
//  miniu
//
//  Created by Apple on 15/11/2.
//  Copyright © 2015年 SimMan. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _headerImg.backgroundColor = [UIColor greenColor];
        [self addSubview:_headerImg];
        
        _tagNameLable = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(_headerImg.frame)-50,CGRectGetWidth(self.frame),50)];
        _tagNameLable.alpha = 0.5;
        _tagNameLable.backgroundColor = [UIColor whiteColor];
        _tagNameLable.textColor = [UIColor whiteColor];
        _tagNameLable.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:_tagNameLable];
        
        _describeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_headerImg.frame), CGRectGetWidth(self.frame), 50)];
        _describeLable.backgroundColor = [UIColor greenColor];
        _describeLable.textColor = [UIColor blackColor];
        _describeLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:_describeLable];
        

    }
    return self;
}


@end
