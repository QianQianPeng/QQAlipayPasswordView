//
//  QQAlipayPasswordView.m
//  QQAlipayPasswordView
//
//  Created by 彭倩倩 on 2019/2/15.
//  Copyright © 2019 彭倩倩. All rights reserved.
//

#import "QQAlipayPasswordView.h"
#import "QQConfirmationTableView.h"
#import "QQEnterPasswordView.h"

static CGFloat const scrollViewHeight = 470;

@interface QQAlipayPasswordView()

/** 父视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 信息确认界面 */
@property (nonatomic, strong) QQConfirmationTableView *confirmationTableView;
/** 输入密码界面 */
@property (nonatomic, strong) QQEnterPasswordView *enterPasswordView;

@end

@implementation QQAlipayPasswordView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatChildViews];
    }
    return self;
}

- (void)creatChildViews {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, scrollViewHeight)];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:scrollView];
    self.scrollView = scrollView;

    scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*2, scrollViewHeight);
    scrollView.scrollEnabled = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [scrollView addSubview:self.confirmationTableView];
    [scrollView addSubview:self.enterPasswordView];
}

#pragma mark - 点击事件区域
- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [weakSelf.scrollView setTransform:CGAffineTransformMakeTranslation(0, -scrollViewHeight)];
        weakSelf.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    } completion:nil];
}

- (void)hidden {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        weakSelf.scrollView.transform = CGAffineTransformIdentity;
        weakSelf.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 懒加载区域
- (QQConfirmationTableView *)confirmationTableView {
    if (!_confirmationTableView) {
        __weak typeof(self) weakSelf = self;
        _confirmationTableView = [[QQConfirmationTableView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, scrollViewHeight) style:UITableViewStylePlain];
        _confirmationTableView.clickBlock = ^(NSInteger tag) {
            if (tag == 0) {
                [weakSelf hidden];
            } else {
                [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.scrollView.frame.size.width, 0) animated:YES];
                [weakSelf.enterPasswordView.codeView.codeTextField becomeFirstResponder];
            }
        };
    }
    return _confirmationTableView;
}

- (QQEnterPasswordView *)enterPasswordView {
    if (!_enterPasswordView) {
        __weak typeof(self) weakSelf = self;
        _enterPasswordView = [[QQEnterPasswordView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, scrollViewHeight)];
        _enterPasswordView.clickBlock = ^(NSInteger tag) {
            if (tag == 0) {
                [weakSelf.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                [weakSelf.enterPasswordView.codeView.codeTextField resignFirstResponder];
                weakSelf.enterPasswordView.codeView.codeTextField.text = @"";
                [weakSelf.enterPasswordView.codeView.labelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ((UILabel *)obj).hidden = YES;
                }];
            }
        };
    }
    return _enterPasswordView;
}

@end
