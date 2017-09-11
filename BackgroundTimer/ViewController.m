//
//  ViewController.m
//  BackgroundTimer
//
//  Created by Kila on 2017/9/8.
//  Copyright © 2017年 Kila. All rights reserved.
//

#import "ViewController.h"
#import "LLBKTimeCounter.h"

@interface ViewController ()
@property (nonatomic,strong) LLBKTimeCounter *timeCounter;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.timeCounter = [[LLBKTimeCounter alloc] initWithIdentifier:@"2"];
    [self.timeCounter startTimer:500 block:^(NSTimer *timer) {
        NSLog(@"%f",self.timeCounter.remaintime);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
