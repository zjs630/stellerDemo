//
//  STCusomImageView.m
//  stellerTest
//
//  Created by 张京顺 on 14-6-30.
//  Copyright (c) 2014年 天天飞度. All rights reserved.
//

#import "STCusomImageView.h"

@implementation STCusomImageView

- (UIImageView *)myImageView
{
    if (_myImageView==nil) {
        _myImageView = [[UIImageView alloc] init];
        [self addSubview:_myImageView];
    }
    return _myImageView;
}

- (UILabel *)wordLabel
{
    if (_wordLabel == nil) {
        _wordLabel = [[UILabel alloc] init];
        _wordLabel.textAlignment = NSTextAlignmentCenter;
        _wordLabel.textColor = [UIColor redColor];
        _wordLabel.font = [UIFont systemFontOfSize:24];
        [self addSubview:_wordLabel];
    }
    return _wordLabel;
}

- (void)addImageForView:(UIImage *)img
{
    CGSize size = img.size;
    float height = size.height*self.bounds.size.width/size.width;
    self.myImageView.frame = CGRectMake(0, 0, self.bounds.size.width, height);
    self.myImageView.image = img;
    
}

- (void)addImageForView:(UIImage *)img withTag:(int)tag
{
    _imgTag = tag;
    [self addImageForView:img];
}

- (void)addWords:(NSString *)word
{
    self.wordLabel.frame = CGRectMake(0, self.bounds.size.height - 160, self.bounds.size.width, 30);
    _wordLabel.text = word;
}

@end
