//
//  FlowerViewController.h
//  Demo
//
//  Created by YDPT2 on 15/2/4.
//  Copyright (c) 2015年 wutongr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *flowerView;
@property (weak, nonatomic) IBOutlet UITextField *durationField;
@property (weak, nonatomic) IBOutlet UITextField *repeatField;

@property (weak, nonatomic) IBOutlet UIButton *startButton;

- (IBAction)start:(id)sender;

@property (nonatomic,strong) CALayer *flowerLayer;


@end
