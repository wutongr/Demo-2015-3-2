//
//  FlowerViewController.m
//  Demo
//
//  Created by YDPT2 on 15/2/4.
//  Copyright (c) 2015年 wutongr. All rights reserved.
//

#import "FlowerViewController.h"

@interface FlowerViewController ()

@end

@implementation FlowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test1];
    // Do any additional setup after loading the view from its nib.
}

-(void)test1{
    self.flowerLayer = [CALayer layer];
    self.flowerLayer.frame = CGRectMake(0, 0, 128, 128);
    self.flowerLayer.position = CGPointMake(150, 150);
    self.flowerLayer.contents = (__bridge id)[UIImage imageNamed:@"flower"].CGImage;
    [self.flowerView.layer addSublayer:self.flowerLayer];
}

-(void)setcontrolsEnabled:(BOOL)enabled{
    for(UIControl *control in @[self.durationField,self.repeatField,self.startButton]){
        control.enabled = enabled;
        control.alpha = enabled? 1.0f: 0.25f;
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)start:(id)sender {
    CFTimeInterval duration = [self.durationField.text doubleValue];
    float repeatCount = [self.repeatField.text floatValue];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = duration;
    animation.repeatCount = repeatCount;
    animation.byValue = @(M_PI * 2);
    animation.delegate = self;
    [self.flowerLayer addAnimation:animation forKey:@"rotateAnimation"];
    [self setcontrolsEnabled:NO];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self setcontrolsEnabled:YES];
}
@end
