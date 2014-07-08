//
//  STCusomImageView.h
//  stellerTest
//
//  Created by 张京顺 on 14-6-30.
//  Copyright (c) 2014年 天天飞度. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STCusomImageView : UIView

@property (nonatomic,strong) UIImageView *myImageView;
@property (nonatomic,strong) UILabel *wordLabel;

@property (nonatomic) int imgTag;

- (void)addImageForView:(UIImage *)img; //添加图片
- (void)addImageForView:(UIImage *)img withTag:(int)tag;

- (void)addWords:(NSString *)word;  //添加文字
@end
