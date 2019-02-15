//
//  QQValidationCodeView.m
//  QQAlipayPasswordView
//
//  Created by 彭倩倩 on 2019/2/15.
//  Copyright © 2019 彭倩倩. All rights reserved.
//

#import "QQValidationCodeView.h"
#define QQCodeViewHeight self.frame.size.height

@interface QQValidationCodeView()<UITextFieldDelegate>

/** label 的数量 */
@property (nonatomic, assign) NSInteger labelCount;
/** label 之间的距离 */
@property (nonatomic, assign) CGFloat labelDistance;

@end

@implementation QQValidationCodeView

- (instancetype)initWithFrame:(CGRect)frame andLabelCount:(NSInteger)labelCount andLabelDistance:(CGFloat)labelDistance {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.labelCount = labelCount;
        self.labelDistance = labelDistance;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    CGFloat labelX;
    CGFloat labelWidth = self.codeTextField.frame.size.width / self.labelCount;
    CGFloat sideLength = labelWidth < QQCodeViewHeight ? labelWidth : QQCodeViewHeight;
    for (int i = 0; i < self.labelCount; i++) {
        if (i == 0) {
            labelX = 0;
        } else {
            labelX = i * (sideLength + self.labelDistance);
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX+sideLength/2-6, sideLength/2-12, 12, 12)];
        label.layer.masksToBounds = YES;
        label.backgroundColor = [UIColor blackColor];
        label.layer.cornerRadius = 6;
        label.hidden = YES;
        [self addSubview:label];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(labelX, sideLength-2, sideLength, 2)];
        bottomLine.backgroundColor = [UIColor blackColor];
        [self addSubview:bottomLine];
        bottomLine.layer.masksToBounds = YES;
        bottomLine.layer.cornerRadius = 1;
        [self.labelArr addObject:label];
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    NSInteger i = textField.text.length;
    if (i == 0) {
        ((UILabel *)[self.labelArr objectAtIndex:0]).hidden = YES;
    } else {
        ((UILabel *)[self.labelArr objectAtIndex:i - 1]).hidden = NO;
        if (self.labelCount > i) {
            ((UILabel *)[self.labelArr objectAtIndex:i]).hidden = YES;
        }
    }
    if (self.codeBlock) {
        self.codeBlock(textField.text);
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    } else if (string.length == 0) {
        return YES;
    } else if (textField.text.length >= self.labelCount) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - 懒加载
- (QQTextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [[QQTextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, QQCodeViewHeight)];
        _codeTextField.backgroundColor = [UIColor clearColor];
        _codeTextField.textColor = [UIColor clearColor];
        _codeTextField.tintColor = [UIColor clearColor];
        _codeTextField.delegate = self;
        _codeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_codeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_codeTextField];
    }
    return _codeTextField;
}

#pragma mark - 懒加载
- (NSMutableArray *)labelArr {
    if (!_labelArr) {
        _labelArr = [NSMutableArray array];
    }
    return _labelArr;
}

@end


@implementation QQTextField

/** 重写 UITextFiled 子类, 解决长按复制粘贴的问题 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
