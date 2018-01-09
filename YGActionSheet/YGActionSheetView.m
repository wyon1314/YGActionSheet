//
//  YGActionSheetView.m
//  YGActionSheet
//
//  Created by wyon on 2018/1/9.
//  Copyright © 2018年 wyon. All rights reserved.
//

#import "YGActionSheetView.h"
#import "Masonry.h"

#define kButtonHeight 45.0
#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
//状态栏
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
//适配iPhoneX 底部非安全区域高度
#define SafeAreaBottomHeight (kStatusBarHeight > 20 ? 34 : 0)

#define UIColorFromRGBA(rgbValue, alphaValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@interface YGActionSheetView ()

@property (nonatomic, strong) UIView *sheetView;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) NSArray *titleAry;
@property (nonatomic, assign) YGActionSheetType type;
@property (nonatomic, assign) CGFloat sheetView_H;

@end

@implementation YGActionSheetView


- (instancetype)initWithTitleAry:(NSArray *)titleAry type:(YGActionSheetType)type {
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        
        self.titleAry = titleAry;
        self.type     = type;
        
        [self setUI];
        [self setFrame];
        
    }
    return self;
    
}

- (void)setUI {
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSheetView)]];
    
    //背景view
    _sheetView = [[UIView alloc] init];
    [self addSubview:_sheetView];
    _sheetView.backgroundColor = UIColorFromRGBA(0xeaeaea, 1);
    
    //取消按钮
    if (_type == YGActionSheetTypeDefault) {
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:[UIColor whiteColor]];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [_sheetView addSubview:_cancelButton];
        [_cancelButton addTarget:self action:@selector(hiddenSheetView) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    //其他按钮
    for (int i = 0; i < _titleAry.count; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_titleAry[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [button setBackgroundColor:[UIColor whiteColor]];
        [self.sheetView addSubview:button];
        
        button.tag = 101 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}

- (void)setFrame {
    
    if (_type == YGActionSheetTypeDefault) {
        //按钮45 + 分割线0.5 + 底部安全区域 + 取消按钮45+4.5
        _sheetView_H = (kButtonHeight * _titleAry.count) + (0.5 * (_titleAry.count - 1)) + SafeAreaBottomHeight + ((1 + 0.1) * kButtonHeight);
    } else {
        //按钮 + 分割线 + 底部安全区域
        _sheetView_H = (kButtonHeight * _titleAry.count) + (0.5 * (_titleAry.count - 1)) + SafeAreaBottomHeight;
    }
    _sheetView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _sheetView_H);
    
    if (_type == YGActionSheetTypeDefault) {
        //取消按钮
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_sheetView);
            make.height.mas_equalTo(kButtonHeight + SafeAreaBottomHeight);
        }];
        
        //其他按钮
        for (int i = 0; i < _titleAry.count; i ++) {
            
            UIButton *button = (UIButton *)[self viewWithTag:101 + i];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.centerX.equalTo(_cancelButton);
                make.height.mas_equalTo(kButtonHeight);
                make.bottom.equalTo(_cancelButton.mas_top).offset(- ((kButtonHeight * 0.1 - 0.5) + i*(kButtonHeight+0.5)));
            }];
            
        }
        
    } else {
        //其他按钮
        for (int i = 0; i < _titleAry.count; i ++) {
            
            UIButton *button = (UIButton *)[self viewWithTag:101 + i];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_sheetView);
                if (i == 0) {
                    make.height.mas_equalTo(kButtonHeight + SafeAreaBottomHeight);
                    make.bottom.equalTo(_sheetView);
                } else {
                    make.height.mas_equalTo(kButtonHeight);
                    make.bottom.equalTo(_sheetView).offset(-((kButtonHeight+SafeAreaBottomHeight+0.5) + (i-1)*(kButtonHeight+0.5)));
                }
            }];
            
        }
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_type == YGActionSheetTypeDefault) {
        [_cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, SafeAreaBottomHeight, 0)];
    } else {
        UIButton *button = (UIButton *)[self viewWithTag:101];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, SafeAreaBottomHeight, 0)];
    }
    
}

//按钮点击事件
- (void)buttonClick:(UIButton *)sender {
    [self hiddenSheetView];
    
    if (self.sheetBlock) {
        _sheetBlock(_titleAry[sender.tag - 101]);
    }

}

- (void)showSheetView {
   
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.35 animations:^{
        
        _sheetView.transform = CGAffineTransformMakeTranslation(0, -_sheetView_H);
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
        
    } completion:^(BOOL finished) {
        
        
    }];
    
}

- (void)hiddenSheetView {
   
    [UIView animateWithDuration:0.35 animations:^{
        
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.0);
        _sheetView.transform = CGAffineTransformMakeTranslation(0, _sheetView_H);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}


@end
