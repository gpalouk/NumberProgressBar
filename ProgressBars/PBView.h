//
//  PBView.h
//  ProgressBars
//
//  Created by Ming-Zhe on 14-5-3.
//  Copyright (c) 2014年 Ming-Zhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface PBView : UIView

@property (nonatomic, strong) UIColor* progressColor;
@property (nonatomic, strong) UIColor* progressBackColor;
@property (nonatomic) CGFloat progress;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
