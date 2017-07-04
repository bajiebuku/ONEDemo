//
//  ViewController.m
//  ONEDemo
//
//  Created by 韩东 on 17/7/4.
//  Copyright © 2017年 HD. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()<UICollisionBehaviorDelegate>

@property (nonatomic, strong) NSMutableArray *balls;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property (nonatomic, strong) UICollisionBehavior *collision;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic) CMMotionManager *MotionManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *clickBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.center.x)-20, (self.view.center.y)-20, 40, 40)];
    [clickBtn setTitle:@"开始" forState:UIControlStateNormal];
    clickBtn.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:clickBtn];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [clickBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickButton:(UIButton *)sender{
    
    [self setBalls];
    [sender removeFromSuperview];
    
}

- (void)setBalls{
    
    self.balls = [NSMutableArray array];
    
    //球的总数
    for (NSUInteger i = 0; i < 25; i ++) {
        
        UIView *ball = [UIView new];
        
        //球的随机颜色
        ball.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        
        //球的位置
        CGRect frame = CGRectMake(arc4random()%((int)(self.view.bounds.size.width - 40)), 0, 40, 40);
        [ball setFrame:frame];
        
        ball.layer.cornerRadius = 20;
        
        [self.view addSubview:ball];
        [self.balls addObject:ball];
    }
    
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    _animator = animator;
    
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:self.balls];
    [self.animator addBehavior:gravity];
    _gravity = gravity;
    
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]initWithItems:self.balls];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collision];
    _collision = collision;
    
    
    UIDynamicItemBehavior *dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.balls];
    dynamicItemBehavior.elasticity = 1;//弹性
    [self.animator addBehavior:dynamicItemBehavior];
    
    
    self.MotionManager = [[CMMotionManager alloc]init];
    
    [self.MotionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *_Nullable motion,NSError * _Nullable error) {
        
        double rotation = atan2(motion.attitude.pitch, motion.attitude.roll);
        
        self.gravity.angle = rotation;
        
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
