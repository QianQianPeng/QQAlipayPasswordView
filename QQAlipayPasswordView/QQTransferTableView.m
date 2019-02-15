//
//  QQTransferTableView.m
//  QQAlipayPasswordView
//
//  Created by 彭倩倩 on 2019/2/15.
//  Copyright © 2019 彭倩倩. All rights reserved.
//

#import "QQTransferTableView.h"
#import "QQAlipayPasswordView.h"

@interface QQTransferTableView()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

/** 尾部视图 */
@property (nonatomic, strong) UIView *transferFooterView;
/** 备注 */
@property (nonatomic, strong) UITextField *noteTextField;
/** 底部按钮 */
@property (nonatomic, strong) UIButton *bottomButton;
/** 判断键盘是否应该弹起 */
@property (nonatomic, assign) BOOL isShouldBounce;

@property (nonatomic, copy) NSArray *leftTitleArray;
@property (nonatomic, strong) NSMutableArray *rightTitleArray;

@end

@implementation QQTransferTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShowWithNotification:) name:UIKeyboardWillShowNotification object:nil];
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        self.tableFooterView = self.transferFooterView;
    }
    return self;
}

#pragma mark - 代理区域
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ident = @"transferTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ident];
    }
    cell.textLabel.text = self.leftTitleArray[indexPath.row];
    cell.detailTextLabel.text = self.rightTitleArray[indexPath.row];
    return cell;
}

- (void)keyBoardWillShowWithNotification:(NSNotification *)notification {
    if (!self.isShouldBounce) {
        return;
    }
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.contentOffset = CGPointMake(0, 100);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.isShouldBounce = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.contentOffset = CGPointMake(0, -[[UIApplication sharedApplication] statusBarFrame].size.height-[UINavigationController new].navigationBar.frame.size.height);
        [self endEditing:YES];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]){
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (_noteTextField == textField) {
        if ([toBeString length] > 20) { // 如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:20];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过最大字数不能输入了" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.noteTextField) {
        self.isShouldBounce = YES;
    } else {
        self.isShouldBounce = NO;
    }
}

- (void)bottomButtonClick {
    [UIView animateWithDuration:0.25 animations:^{
        self.contentOffset = CGPointMake(0, -[[UIApplication sharedApplication] statusBarFrame].size.height-[UINavigationController new].navigationBar.frame.size.height);
        [self endEditing:YES];
        self.isShouldBounce = NO;
        QQAlipayPasswordView *passwordView = [[QQAlipayPasswordView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [passwordView show];
    }];
}

#pragma mark - 懒加载区域
- (UIView *)transferFooterView {
    if (!_transferFooterView) {
        _transferFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 200)];
        _noteTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, 0, _transferFooterView.frame.size.width-32, 30)];
        _noteTextField.textColor = [UIColor blackColor];
        _noteTextField.font = [UIFont systemFontOfSize:14.f];
        _noteTextField.placeholder = @"添加备注（20字以内）";
        _noteTextField.delegate = self;
        [_transferFooterView addSubview:_noteTextField];

        UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bottomButton = bottomButton;
        bottomButton.frame = CGRectMake(30, 100, _transferFooterView.frame.size.width-60, 45);
        [bottomButton setTitle:@"转账" forState:UIControlStateNormal];
        bottomButton.titleLabel.font = [UIFont systemFontOfSize:14];
        bottomButton.backgroundColor = [UIColor blueColor];
        [bottomButton addTarget:self action:@selector(bottomButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_transferFooterView addSubview:bottomButton];

        bottomButton.layer.masksToBounds = YES;
        bottomButton.layer.cornerRadius = 45/2.0;
    }
    return _transferFooterView;
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
