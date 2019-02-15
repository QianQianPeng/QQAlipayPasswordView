//
//  QQTransferViewController.m
//  QQAlipayPasswordView
//
//  Created by 彭倩倩 on 2019/2/15.
//  Copyright © 2019 彭倩倩. All rights reserved.
//

#import "QQTransferViewController.h"
#import "QQTransferTableView.h"

@interface QQTransferViewController ()

@property (nonatomic, strong) QQTransferTableView *tableView;

@end

@implementation QQTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转账";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - 懒加载区域
- (QQTransferTableView *)tableView {
    if (!_tableView) {
        _tableView = [[QQTransferTableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    }
    return _tableView;
}

@end
