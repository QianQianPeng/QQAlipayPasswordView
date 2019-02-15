//
//  QQValidationCodeView.h
//  QQAlipayPasswordView
//
//  Created by 彭倩倩 on 2019/2/15.
//  Copyright © 2019 彭倩倩. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QQTextField;

typedef void(^NNCodeDidChangeBlock)(NSString *codeString);

@interface QQValidationCodeView : UIView

- (instancetype)initWithFrame:(CGRect)frame andLabelCount:(NSInteger)labelCount andLabelDistance:(CGFloat)labelDistance;

/** 回调的 block , 获取输入的数字 */
@property (nonatomic, copy) NNCodeDidChangeBlock codeBlock;
/** 输入文本框 */
@property (nonatomic, strong) QQTextField *codeTextField;
/** 存放 label 的数组 */
@property (nonatomic, strong) NSMutableArray *labelArr;

@end

@interface QQTextField : UITextField

@end

NS_ASSUME_NONNULL_END
