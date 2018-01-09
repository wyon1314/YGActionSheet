//
//  YGActionSheetView.h
//  YGActionSheet
//
//  Created by wyon on 2018/1/9.
//  Copyright © 2018年 wyon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YGActionSheetType){
    YGActionSheetTypeDefault = 0 ,  //默认
    YGActionSheetTypeNoCancel       //无取消按钮
};

typedef void(^YGActionSheetBlock)(NSString *title);

@interface YGActionSheetView : UIView

@property (nonatomic, copy) YGActionSheetBlock sheetBlock;

- (instancetype)initWithTitleAry:(NSArray *)titleAry type:(YGActionSheetType)type;
- (void)showSheetView;

@end
