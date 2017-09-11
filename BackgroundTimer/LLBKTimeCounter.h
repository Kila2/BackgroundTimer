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

- (instancetype)initWithIdentifier:(NSString *)identifier;
- (void)startTimer:(NSTimeInterval)remaintime block:(void (^)(NSTimer *timer))block;

@end
