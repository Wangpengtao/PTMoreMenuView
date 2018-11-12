//
//  ViewController.m
//  PTMoreMenuView
//
//  Created by ZQ on 2018/11/12.
//  Copyright © 2018年 ZQ. All rights reserved.
//

#import "ViewController.h"
#import "PTMoreMenuView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 30)];
    label.text = @"不要点我";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0.22f green:0.69f blue:0.99f alpha:1.00f];
    [self.view addSubview:label];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [PTMoreMenuView showMoreWithTitle:@[@"拍发票",@"看照片",@"拍发票",@"看照片",@"拍发票",@"看照片",@"拍发票",@"看照片"] imgNameArray:@[@"拍发票",@"看照片",@"拍发票",@"看照片",@"拍发票",@"看照片",@"拍发票",@"看照片"] blockTapAction:^(NSInteger index) {
        
        NSLog(@"%zd",index);
    }];
}


@end
