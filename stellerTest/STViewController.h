//
//  STViewController.h
//  stellerTest
//
//  Created by 张京顺 on 14-6-30.
//  Copyright (c) 2014年 天天飞度. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STViewController : UIViewController
{
    CGPoint startTouch;
}

@property (nonatomic,assign) BOOL isMoving;
@property (nonatomic,strong) NSMutableArray *viewMutableArray;
@property (nonatomic,strong) NSArray *imageArray;

@end
