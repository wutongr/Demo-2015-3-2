//
//  ViewController.h
//  Demo
//
//  Created by YDPT2 on 15/1/20.
//  Copyright (c) 2015年 wutongr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct pp{
    char *ss;
    char *mm;
}sss;

static sss aa[] = {
    {"hah","mm"}
};

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *faces;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

