//
//  QQEnterPasswordView.h
//  QQAlipayPasswordView
//
//  Created by 彭倩倩 on 2019/2/15.
//  Copyright © 2019 彭倩倩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QQValidationCodeView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^QQUsuallyBlock)(NSInteger tag);

@interface QQEnterPasswordView : UIView

@property (nonatomic, copy) QQUsuallyBlock clickBlock;

@property (nonatomic, strong) QQValidationCodeView *codeView;

@end

NS_ASSUME_NONNULL_END
