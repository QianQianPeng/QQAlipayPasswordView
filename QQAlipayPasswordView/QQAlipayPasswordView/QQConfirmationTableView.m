//
//  QQConfirmationTableView.m
//  QQAlipayPasswordView
//
//  Created by 彭倩倩 on 2019/2/15.
//  Copyright © 2019 彭倩倩. All rights reserved.
//

#import "QQConfirmationTableView.h"

@interface QQConfirmationTableView()<UITableViewDelegate, UITableViewDataSource>
/** 尾 */
@property (nonatomic, strong) UIView *cashFooterView;
/** 头 */
@property (nonatomic, strong) UIView *cashHeaderView;
/** 底部按钮 */
@property (nonatomic, strong) UIButton *bottomButton;

@property (nonatomic, copy) NSArray *leftTitleArray;
@property (nonatomic, strong) NSMutableArray *rightTitleArray;
@end

@implementation QQConfirmationTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableHeaderView = self.cashHeaderView;
        self.tableFooterView = self.cashFooterView;
    }
    return self;
}

#pragma mark - 代理区域
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ident = @"QQConfirmationTableViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ident];
    }
    cell.textLabel.text = self.leftTitleArray[indexPath.row];
    cell.detailTextLabel.text = self.rightTitleArray[indexPath.row];
    return cell;
}

#pragma mark - 点击事件区域
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (void)bottomButtonClick:(UIButton *)sender {
    if (self.clickBlock) {
        self.clickBlock(sender.tag);
    }
}

#pragma mark - 懒加载区域
- (UIView *)cashFooterView {
    if (!_cashFooterView) {
        _cashFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
        UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        bottomButton.tag = 1;
        self.bottomButton = bottomButton;
        bottomButton.frame = CGRectMake(30, 30, [UIScreen mainScreen].bounds.size.width-60, 45);
        [bottomButton setTitle:@"立即付款" forState:UIControlStateNormal];
        bottomButton.titleLabel.font = [UIFont systemFontOfSize:14];
        bottomButton.backgroundColor = [UIColor blueColor];
        [bottomButton addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cashFooterView addSubview:bottomButton];
        bottomButton.layer.masksToBounds = YES;
        bottomButton.layer.cornerRadius = 45/2.0;
    }
    return _cashFooterView;
}

- (UIView *)cashHeaderView {
    if (!_cashHeaderView) {
        UIView *cashHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
        _cashHeaderView = cashHeaderView;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, cashHeaderView.frame.size.width-200, 30)];
        titleLabel.text = @"确认付款";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.textColor = [UIColor blackColor];
        [_cashHeaderView addSubview:titleLabel];
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.tag = 0;
        leftButton.frame = CGRectMake(15, 20, 30, 30);
        [leftButton setImage:[UIImage imageNamed:@"navigation_close_black"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cashHeaderView addSubview:leftButton];
    }
    return _cashHeaderView;
}

- (NSArray *)leftTitleArray {
    if (!_leftTitleArray) {
        _leftTitleArray = @[@"支付类型", @"收款地址", @"矿工费用", @"转账备注"];
    }
    return _leftTitleArray;
}

- (NSMutableArray *)rightTitleArray {
    if (!_rightTitleArray) {
        _rightTitleArray= @[@"支付类型", @"收款地址", @"矿工费用", @"转账备注"].mutableCopy;
    }
    return _rightTitleArray;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
