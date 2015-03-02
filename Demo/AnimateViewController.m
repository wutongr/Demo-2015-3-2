//
//  AnimateViewController.m
//  Demo
//
//  Created by Yorke on 15/1/26.
//  Copyright (c) 2015年 wutongr. All rights reserved.
//

#import "AnimateViewController.h"

@interface AnimateViewController ()

@property (nonatomic, strong) CALayer *colorLayer;

@property (weak, nonatomic) IBOutlet UIView *layerView;


@end

@implementation AnimateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    
     [self test1];
    
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    NSLog(@"耗时:%f",end - start);
    // Do any additional setup after loading the view from its nib.
}

-(void)test1{
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    self.colorLayer.actions = @{@"backgroundColor":transition};
    
    [self.layerView.layer addSublayer:self.colorLayer];
}

-(void)test2{
    self.layerView.layer.backgroundColor = [UIColor blueColor].CGColor;
}

-(void)test3{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.duration = 2.0f;
    animation.values = @[
                         (__bridge id)[UIColor blueColor].CGColor,
                         (__bridge id)[UIColor redColor].CGColor,
                         (__bridge id)[UIColor greenColor].CGColor,
                         (__bridge id)[UIColor blueColor].CGColor]
                         ;
    [self.colorLayer addAnimation:animation forKey:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)change:(id)sender {
    
    [self test3];
////    [CATransaction begin];
////    [CATransaction setAnimationDuration:1.0f];
//    CGFloat red = arc4random_uniform(255);
//    CGFloat green = arc4random_uniform(255);
//    CGFloat blue = arc4random_uniform(255);
//    UIColor *color = [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:1];
////    self.colorLayer.backgroundColor = [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:1].CGColor;
//    CABasicAnimation *animation = [CABasicAnimation animation];
//    animation.keyPath = @"backgroundColor";
////    animation.fromValue = (__bridge id)self.colorLayer.backgroundColor;
//    animation.toValue = (__bridge id)color.CGColor;
////    self.colorLayer.backgroundColor = color.CGColor;
////    [self.colorLayer addAnimation:animation forKey:nil];
////    [CATransaction commit];
//    [self applyBasicAnimation:animation toLayer:self.colorLayer];
}

-(void)applyBasicAnimation:(CABasicAnimation *)animation toLayer:(CALayer *)layer{
    animation.fromValue = [layer.presentationLayer ?:layer valueForKeyPath:animation.keyPath];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [layer setValue:animation.toValue forKeyPath:animation.keyPath];
    [CATransaction commit];
    [layer addAnimation:animation forKey:nil];
}

-(void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag{
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    self.colorLayer.backgroundColor = (__bridge CGColorRef)anim.toValue;
    [CATransaction commit];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self.view];
    if([self.colorLayer.presentationLayer hitTest:point]){
        CGFloat red = arc4random_uniform(255);
        CGFloat green = arc4random_uniform(255);
        CGFloat blue = arc4random_uniform(255);
        self.colorLayer.backgroundColor = [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:1].CGColor;
    }else{
        [CATransaction begin];
        [CATransaction setAnimationDuration:4.0];
        self.colorLayer.position = point;
        [CATransaction commit];
    }
}











@end
