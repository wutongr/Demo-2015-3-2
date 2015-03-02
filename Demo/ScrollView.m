//
//  ScrollView.m
//  Demo
//
//  Created by Yorke on 15/1/26.
//  Copyright (c) 2015年 wutongr. All rights reserved.
//

#import "ScrollView.h"

@implementation ScrollView

+(Class)layerClass{
    return [CAScrollLayer class];
}

-(void)setUp{
    self.layer.masksToBounds = YES;
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:recognizer];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setUp];
    }
    return self;
}

-(void)awakeFromNib{
    [self setUp];
}

-(void)pan:(UIPanGestureRecognizer *)recognizer{
    CGPoint offset = self.bounds.origin;
    offset.x -= [recognizer translationInView:self].x;
    offset.y -= [recognizer translationInView:self].y;
    
    [(CAScrollLayer *)self.layer scrollPoint:offset];
    
    [recognizer setTranslation:CGPointZero inView:self];
}
@end
