//
//  DemoModule.m
//  Demo
//
//  Created by Yorke on 15/1/22.
//  Copyright (c) 2015年 wutongr. All rights reserved.
//

#import "DemoModule.h"

@interface DemoModule (){
    float tip;
}

@end

@implementation DemoModule

-(instancetype)init{
    if(self = [super init]){
        self.mult(20).plus();
        
        NSLog(@"%f",tip);
    }
    return self;
}

-(DemoModule *(^)(float))mult{
    return ^id(float multip){
        tip = multip;
        //
        return self;
    };
}


-(DemoModule *(^)())plus{
    return ^id{
        //
        return self;
    };
}

@end
