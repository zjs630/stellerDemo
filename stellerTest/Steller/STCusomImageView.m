//
//  STCusomImageView.m
//  stellerTest
//
//  Created by 张京顺 on 14-6-30.
//  Copyright (c) 2014年 天天飞度. All rights reserved.
//

#import "STCusomImageView.h"

@implementation STCusomImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

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
        [self addSubview:_wordLabel];
        
        
        
    }
    return _wordLabel;
}

- (void)addImageForView:(UIImage *)img
{
    CGSize size = img.size;
    self.myImageView.frame = CGRectMake(0, 0, size.width/2, size.height/2);
    self.myImageView.image = img;
    
}

- (void)addImageForView:(UIImage *)img withTag:(int)tag
{
    _imgTag = tag;
    [self addImageForView:img];
}

- (void)addWords:(NSString *)word
{
    self.wordLabel.frame = CGRectMake(0, 20, 320, 30);
    _wordLabel.text = word;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
