//
//  QQConfirmationTableView.h
//  QQAlipayPasswordView
//
//  Created by 彭倩倩 on 2019/2/15.
//  Copyright © 2019 彭倩倩. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef void (^QQUsuallyBlock)(NSInteger tag);


@interface QQConfirmationTableView : UITableView

@property (nonatomic, copy) QQUsuallyBlock clickBlock;

@end

NS_ASSUME_NONNULL_END
