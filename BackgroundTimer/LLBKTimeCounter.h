//
//  LLBKTimeCounter.h
//  BackgroundTimer
//
//  Created by Kila on 2017/9/8.
//  Copyright © 2017年 Kila. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLBKTimeCounter : NSObject
@property (nonatomic,assign) NSTimeInterval remaintime;

- (void)startTimer:(NSTimeInterval)interval block:(void (^)(NSTimer *timer))block;

@end
