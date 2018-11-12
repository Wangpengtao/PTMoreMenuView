//
//  ZQMoreModeView.m
//  erp
//
//  Created by ZQ on 2018/11/12.
//  Copyright © 2018年 PT. All rights reserved.
//

#import "PTMoreMenuView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define ItemH kw(100)
#define kw(R)   (R) * (kScreenWidth) / 375.0


@interface PTMoreMenuView ()
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imgNameArray;
@property (nonatomic, copy) void (^blockTapAction)(NSInteger index);
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@end

@implementation PTMoreMenuView

+ (void)showMoreWithTitle:(NSArray *)titleArray
             imgNameArray:(NSArray *)imgNameArray
           blockTapAction:( void(^)(NSInteger index) )blockTapAction{
    if (titleArray.count != imgNameArray.count || !titleArray.count) {
        return;
    }
    
    PTMoreMenuView *modeView = [[PTMoreMenuView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    modeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    modeView.alpha = 0;
    modeView.titleArray = titleArray;
    modeView.imgNameArray = imgNameArray;
    modeView.blockTapAction = blockTapAction;
    [[UIApplication sharedApplication].keyWindow addSubview:modeView];
    
    // 创建内容
    [modeView bulidContentView];
    
    [modeView show];
    [modeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:modeView action:@selector(dismiss)]];
}

- (void)bulidContentView{
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kw(50) + ((self.titleArray.count-1)/4+1)*ItemH + kw(30))];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(kw(20), kw(15))];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.contentView.layer addSublayer:shapeLayer];
    [self addSubview:self.contentView];
    
    [self bulidContent];
    [self bulidCancle];
}

- (void)bulidContent{
    
    self.buttonArray = [[NSMutableArray alloc] init];
    CGFloat itemW = (self.contentView.bounds.size.width-kw(30))/4;
    for (int i = 0; i < self.titleArray.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.frame = CGRectMake(kw(15) + i%4*itemW, kw(10) + i/4*ItemH, itemW, ItemH);
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.46f green:0.50f blue:0.54f alpha:1.00f] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:self.imgNameArray[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        // button标题/图片的偏移量
        button.titleEdgeInsets = UIEdgeInsetsMake(button.imageView.bounds.size.height + kw(10), -button.imageView.bounds.size.width, 0,0);
        button.imageEdgeInsets = UIEdgeInsetsMake(kw(5), button.titleLabel.bounds.size.width/2, button.titleLabel.bounds.size.height + kw(5), -button.titleLabel.bounds.size.width/2);
        [self.buttonArray addObject:button];
        
        button.alpha = 0;
        button.transform = CGAffineTransformMakeTranslation(0, self.contentView.bounds.size.height);
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showButton];
    });
}

- (void)showButton{
    
    for (int i = 0; i < self.buttonArray.count; i++) {
        
        UIButton *button = self.buttonArray[i];
        
        [UIView animateWithDuration:0.7 delay:i*0.05 - i/4*0.2 usingSpringWithDamping:0.7 initialSpringVelocity:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            button.alpha = 1;
            button.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }
}

// 取消按钮
- (void)bulidCancle{
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(0, self.contentView.bounds.size.height - kw(50), self.contentView.bounds.size.width, kw(50));
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor colorWithRed:0.22f green:0.69f blue:0.99f alpha:1.00f] forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, cancleButton.bounds.size.width, 1);
    layer.backgroundColor = [UIColor colorWithRed:0.98f green:0.98f blue:0.98f alpha:1.00f].CGColor;
    [cancleButton.layer addSublayer:layer];

    [self.contentView addSubview:cancleButton];
}

- (void)addLineWithFrame:(CGRect)frame color:(UIColor *)color{
    
    CALayer *layer = [CALayer layer];
    layer.frame = frame;
    layer.backgroundColor = color.CGColor;
    [self.layer addSublayer:layer];
}

- (void)show{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.alpha = 1;
        self.contentView.transform = CGAffineTransformMakeTranslation(0, -self.contentView.bounds.size.height);
    }];
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.alpha = 0;
        self.contentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)tapAction:(UIButton *)button{
    
    [self dismiss];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.blockTapAction) {
            self.blockTapAction(button.tag);
        }
    });
}

@end
