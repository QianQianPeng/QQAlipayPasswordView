//
//  QQEnterPasswordView.m
//  QQAlipayPasswordView
//
//  Created by 彭倩倩 on 2019/2/15.
//  Copyright © 2019 彭倩倩. All rights reserved.
//

#import "QQEnterPasswordView.h"

@interface QQEnterPasswordView()

@end

@implementation QQEnterPasswordView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatChildViews];
    }
    return self;
}

- (void)creatChildViews {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, [UIScreen mainScreen].bounds.size.width-200, 30)];
    titleLabel.text = @"请输入支付密码";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.textColor = [UIColor blackColor];
    [self addSubview:titleLabel];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.tag = 0;
    leftButton.frame = CGRectMake(0, 20, 30, 30);
    [leftButton setImage:[UIImage imageNamed:@"navigation_back_black"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftButton];
    
    _codeView = [[QQValidationCodeView alloc] initWithFrame:CGRectMake((self.frame.size.width-300)/2.0, 80, 300, 40) andLabelCount:6 andLabelDistance:12];
    [self addSubview:_codeView];
    _codeView.codeBlock = ^(NSString *codeString) {
        if (codeString.length >= 6) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"输入的密码是：%@", codeString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    };
}

#pragma mark - 点击事件区域
- (void)bottomButtonClick:(UIButton *)sender {
    if (self.clickBlock) {
        self.clickBlock(sender.tag);
    }
}

@end
