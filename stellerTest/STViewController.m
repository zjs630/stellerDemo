//
//  STViewController.m
//  stellerTest
//
//  Created by 张京顺 on 14-6-30.
//  Copyright (c) 2014年 天天飞度. All rights reserved.
//

#import "STViewController.h"
#import "STCusomImageView.h"

typedef NS_ENUM(NSInteger, PanAction){
    RightAction = 1,    // 向前滑动
    LeftAction,         // 向后滑动
    RightCancelAction,  //向右滑动取消
    //LeftCancelAction,   //向左滑动取消
    CancellAction,      // 取消滑动
    Others
};

#define KEY_WINDOW  [[UIApplication sharedApplication] keyWindow]
#define TOP_VIEW    [[UIApplication sharedApplication] keyWindow].rootViewController.view

@interface STViewController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic,assign) PanAction panAction;

@end

@implementation STViewController

- (NSMutableArray *)viewMutableArray
{
    if (!_viewMutableArray) {
        _viewMutableArray = [[NSMutableArray alloc] init];
    }
    return _viewMutableArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageArray = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg", @"6.jpg"];//初始化数据
    [self createViewForReuse];
}

/**
 初期要创建两个需要重用的View
 */
- (void)createViewForReuse
{
    if ([self.viewMutableArray count] > 0) {
        return;
    }

    NSUInteger count = self.imageArray.count;

    if (count == 0) {
        return;
    }
    if (count == 1) {
        [self createCusomImageViewToArray:0];
    } else if (count > 1) {
        [self createCusomImageViewToArray:0];
        [self createCusomImageViewToArray:1];
    }
}

- (void)addTransformToView:(UIView *)v withHudu:(CGFloat)hudu isTouShi:(BOOL)isYes
{
    v.layer.anchorPoint = CGPointMake(0, 0.5);
    CATransform3D transform2 = CATransform3DIdentity;
    transform2.m41 = -self.view.bounds.size.width/2;
    if (isYes) {
        transform2.m34 = -1 / 2000.0; // 透视效果
    }
    transform2 = CATransform3DRotate(transform2, hudu, 0, 1, 0);
    [v.layer setTransform:transform2];
}

#pragma mark - 数据操作

// 创建页面，添加到页面数组
- (void)createCusomImageViewToArray:(int)i
{
    int y = 0;
    if (self.view.frame.size.height>480) {
        y = 44;
    }

    STCusomImageView *vi = [[STCusomImageView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height)];

    [vi addImageForView:[UIImage imageNamed:self.imageArray[i]] withTag:i + 1];
    [vi addWords:[NSString stringWithFormat:@"这是第%d张图片", i + 1]];
    [self.view insertSubview:vi atIndex:0];

    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                        action:@selector(paningGestureReceive:)];
    recognizer.delegate = self;
    [vi addGestureRecognizer:recognizer];

    [self.viewMutableArray addObject:vi];
}

// 向后添加数据 //采用视图重用机制
- (void)addNewDataToViewMutableArray:(int)vIndex
{
    if ([self.viewMutableArray count] == 2) {
        if (self.imageArray.count>2) {
            [self createCusomImageViewToArray:2];
        }
        return;
    }

    // 到这里至少有三个盒子了。
    int dataCount = (int)[self.imageArray count];
    STCusomImageView *vi = (STCusomImageView *)[self.viewMutableArray objectAtIndex:0];
    int imgTag = vi.imgTag;

    if ((vIndex == 1) && (imgTag < dataCount - 2)) { // 如果后面还有数据
        // 移动的是第二个盒子，展示出第三个盒子。之后将第一个盒子移动到第三个盒子后面
        [self.view sendSubviewToBack:vi];
        // 改变顺序
        [self.viewMutableArray addObject:vi];
        [self.viewMutableArray removeObjectAtIndex:0];
        // 改变数据
        [vi addImageForView:[UIImage imageNamed:self.imageArray[imgTag + 2]] withTag:imgTag + 3];
        [vi addWords:[NSString stringWithFormat:@"这是第%d张图片", imgTag + 3]];
        
        //隐藏vi的动画，暂时不知道更好的复位方法。
        [UIView animateWithDuration:0.1 animations:^{
            vi.hidden = YES;
            [self addTransformToView:vi withHudu:0 isTouShi:NO];
        } completion:^(BOOL finished) {
            vi.hidden = NO;
        }];
    }
}

// 向前翻页，
- (void)forwardReuseData:(int)vIndex
{
    if (vIndex == 2) {
        // 当前是第三个盒子，要展示的是第二个盒子。不用换位置。
    } else if (vIndex == 1) { // 当前是第二个盒子，要展示的是第一个盒子。将第三个盒子移动到第一位置。
        STCusomImageView    *vi = (STCusomImageView *)[self.viewMutableArray lastObject];
        int                 imgTag = vi.imgTag;

        if (imgTag <= 3) { // 最后一个盒子，是第二张或者第三张图片时，不进行置换。
            return;
        }

        [self.view bringSubviewToFront:vi];
        // 改变顺序
        [self.viewMutableArray insertObject:vi atIndex:0];
        [self.viewMutableArray removeLastObject];
        // 改变数据
        [vi addImageForView:[UIImage imageNamed:self.imageArray[imgTag - 4]] withTag:imgTag - 3];
        [vi addWords:[NSString stringWithFormat:@"这是第%d张图片", imgTag - 3]];

        [self restoreRightMove:vi];
    }
}

//恢复到取消右移前的状态
- (void)restoreRightMove:(STCusomImageView *)vi
{
    [UIView animateWithDuration:0.1 animations:^{
        vi.hidden = YES;
        [self addTransformToView:vi withHudu:M_PI_2 isTouShi:NO];
    } completion:^(BOOL finished) {
        vi.hidden = NO;
    }];

}
#pragma mark -

// set lastScreenShotView 's position and alpha when paning
- (void)moveViewWithX:(float)x withView:(UIView *)touchView
{
    UIView  *animationView = nil;
    int     vIndex = (int)[self.viewMutableArray indexOfObject:touchView];
    CGFloat w = self.view.bounds.size.width;
    x = x > w ? w : x;

    if (vIndex == 0) {
        if (_panAction == RightAction) { // 向前翻页
            return;
        }

        if (_panAction == LeftAction) { // 向后翻页
            if (self.imageArray.count == 1) {//只有一个页面不添加数据
                return;
            }
            animationView = touchView;
            x = -w;
            [self addNewDataToViewMutableArray:vIndex];
        } else {
            if (x <= 0) {
                if (self.imageArray.count > 1) {//只有一个页面不翻页
                    animationView = touchView;
                }
            } else {return; }
        }
    } else if (vIndex == 1) {
        if (x == 0) {
            if (_panAction == CancellAction) { // 取消操作
                animationView = touchView;
            }
            else if (_panAction == RightCancelAction){
                [self restoreRightMove:(STCusomImageView *)[self.viewMutableArray objectAtIndex:vIndex - 1]];
                return;
            }
        } else if (x == w) {
            if (_panAction == LeftAction) { // 向后翻页
                if (self.imageArray.count == 2) {
                    return;
                }
                animationView = touchView;
                x = -w;
                [self addNewDataToViewMutableArray:vIndex];
            } else if (_panAction == RightAction) { // 向前翻页
                animationView = (UIView *)[self.viewMutableArray objectAtIndex:vIndex - 1];
                x = 0;
                [self forwardReuseData:vIndex];
            }
        } else if (x > 0) {
            animationView = (UIView *)[self.viewMutableArray objectAtIndex:vIndex - 1];
            x = x - w;
        } else if (x < 0) {
            NSLog(@"xxddd");
            if (self.imageArray.count > 2) {
                animationView = touchView;
            }
        }
    } else if (vIndex == 2) {
        if (_panAction == LeftAction) {
            return;
        }

        if (_panAction == RightAction) { // 向前翻页
            animationView = (UIView *)[self.viewMutableArray objectAtIndex:vIndex - 1];
            x = 0;
            [self forwardReuseData:vIndex];
        }
        else if (_panAction == RightCancelAction){
            [self restoreRightMove:(STCusomImageView *)[self.viewMutableArray objectAtIndex:vIndex - 1]];
            return;
        }
        else {
            if (x == 0) {
                animationView = touchView;
            } else if (x > 0) {
                x = x - w;
                animationView = (UIView *)[self.viewMutableArray objectAtIndex:vIndex - 1];
            } else {
                NSLog(@"向左滑动！不操作");
                return;
            }
        }
    }

    float hudu = x / w * M_PI_2;

    NSLog(@"Move to:%f|||| %f", x, hudu);

    [self addTransformToView:animationView withHudu:hudu isTouShi:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

#pragma mark - Gesture Recognizer -

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    // If the viewControllers has only one vc or disable the interaction, then return.
    _panAction = Others;
    UIView *touchView = recoginzer.view;
    // we get the touch position by the window's coordinate
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];

    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        _isMoving = YES;
        startTouch = touchPoint;

        // End paning, always check that if it should move right or move left automatically
    } else if (recoginzer.state == UIGestureRecognizerStateEnded) {
        float yidonglength = touchPoint.x - startTouch.x;
        NSLog(@"移动距离:%f|||| ", yidonglength);

        if (fabsf(yidonglength) > 50) {
            if (yidonglength < 0) { // 向后翻页
                _panAction = LeftAction;//NSLog(@"向后翻页");
            } else {
                _panAction = RightAction;//NSLog(@"向前翻页");
            }

            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:self.view.bounds.size.width withView:touchView];
            } completion:^(BOOL finished) {
                _isMoving = NO;
            }];
        } else {
            if (yidonglength < 0) { // 向后翻页
                _panAction = CancellAction;//NSLog(@"向左滑动翻页取消");
            } else {
                _panAction = RightCancelAction;//NSLog(@"向右滑动翻页取消");
            }
            [UIView animateWithDuration:0.3 animations:^{
                //NSLog(@"取消翻页");
                [self moveViewWithX:0 withView:touchView];
            } completion:^(BOOL finished) {
                _isMoving = NO;
            }];
        }

        return;

        // cancal panning, alway move to left side automatically
    } else if (recoginzer.state == UIGestureRecognizerStateCancelled) {
        _panAction = CancellAction;
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0 withView:touchView];
        } completion:^(BOOL finished) {
            _isMoving = NO;
        }];

        return;
    }

    // it keeps move with touch
    if (_isMoving) {
        float moveNumber = touchPoint.x - startTouch.x;
        if (moveNumber == 0) {
            return;
        }

        [self moveViewWithX:moveNumber withView:touchView];
    }
}

@end
