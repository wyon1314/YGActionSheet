//
//  ViewController.m
//  YGActionSheet
//
//  Created by wyon on 2018/1/9.
//  Copyright © 2018年 wyon. All rights reserved.
//

#import "ViewController.h"
#import "YGActionSheetView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:button];
        button.frame = CGRectMake(100, 100 * (i + 1), 100, 50);
        
        [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor redColor];
        button.tag = 11 + i;
        [button addTarget:self action:@selector(showSheetView:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)showSheetView:(UIButton *)sender {
    
    YGActionSheetType type;
    if (sender.tag == 11) {
        type = YGActionSheetTypeDefault;
    } else {
        type = YGActionSheetTypeNoCancel;
    }
    
    YGActionSheetView *sheetView = [[YGActionSheetView alloc] initWithTitleAry:@[@"title1", @"title2", @"title3", @"title4"] type:type];
    [sheetView showSheetView];
    
    sheetView.sheetBlock = ^(NSString *title) {
        NSLog(@"%@", title);
    };
    
}


@end
