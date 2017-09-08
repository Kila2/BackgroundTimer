//
//  LLBKTimeCounter.m
//  BackgroundTimer
//
//  Created by Kila on 2017/9/8.
//  Copyright © 2017年 Kila. All rights reserved.
//

#import "LLBKTimeCounter.h"



typedef void (^CTPTaskBlock)(NSTimer *timer);
static BOOL isFirstBecomeActive = YES;

@interface LLBKTimeCounter ()
@property (nonatomic,assign) NSTimeInterval timeSpace;
@property (nonatomic,assign) NSTimeInterval timeEnterBackground;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,copy)   CTPTaskBlock block;
@end

@implementation LLBKTimeCounter

+ (LLBKTimeCounter *)timeCounter {
    LLBKTimeCounter *timeCounter = [[LLBKTimeCounter alloc] init];
    return timeCounter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initProperty];
    }
    return self;
}


- (void)startTimer:(NSTimeInterval)remaintime block:(void (^)(NSTimer *timer))block {
    if (self.timer!=nil&&[self.timer isValid]){
        NSLog(@"Timer is still running this code is invalid");
        return;
    }
    
    self.remaintime = remaintime;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        self.remaintime--;
        if (self.remaintime <= 0) {
            [self.timer invalidate];
            self.timer = nil;
        }
        block(self.timer);
        if (self.remaintime <= 0) {
            NSLog(@"Timer is stop");
        }
    }];
    self.block = block;
}

- (void)initProperty {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    self.timeSpace = [self readTimeSpaceFormDB];
    self.timeEnterBackground = 0;
}

- (void)didEnterBackground {
    self.timeEnterBackground = [[NSDate date] timeIntervalSinceReferenceDate];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)didBecomeActive {
    if(!isFirstBecomeActive&&self.remaintime>=0) {
        [self startTimer:self.remaintime - self.timeSpace block:self.block];
    }
    isFirstBecomeActive = NO;
}

- (NSTimeInterval)readTimeSpaceFormDB {
    //TODO:readTimeFromCache
    return 0;
}

- (NSTimeInterval)timeSpace {
    return [[NSDate date] timeIntervalSinceReferenceDate] - self.timeEnterBackground;
}


@end
